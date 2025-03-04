#include "segment.h"

#include <string>
#include <vector>

#include <ruby/encoding.h>

#include <mecab.h>

namespace ext_mecab
{
    // Only support UTF-8 encoding
    static rb_encoding *utf8_encoding;

    struct SegmentWrapper
    {
        MeCab::Model *model;
        MeCab::Tagger *tagger;
    };

    void segment_free(void *data)
    {
        SegmentWrapper *wrapper = (SegmentWrapper *)data;

        if (wrapper->tagger)
        {
            delete wrapper->tagger;
        }

        if (wrapper->model)
        {
            delete wrapper->model;
        }
        delete wrapper;
    }

    size_t segment_size(const void *data)
    {
        return sizeof(SegmentWrapper);
    }

    static const rb_data_type_t segment_data_type = {
        .wrap_struct_name = "MeCabSegment",
        .function = {
            .dmark = NULL,
            .dfree = segment_free,
            .dsize = segment_size,
        },
    };

    VALUE segment_alloc(VALUE self)
    {
        SegmentWrapper *wrapper = new SegmentWrapper();
        return TypedData_Wrap_Struct(self, &segment_data_type, wrapper);
    }

    void segment_initialize(VALUE self, VALUE model_argv)
    {
        SegmentWrapper *wrapper;
        TypedData_Get_Struct(self, SegmentWrapper, &segment_data_type, wrapper);

        wrapper->model = MeCab::Model::create(StringValueCStr(model_argv));
        if (!wrapper->model)
        {
            rb_raise(rb_eRuntimeError, "Failed to create MeCab model: %s", MeCab::getLastError());
        }

        wrapper->tagger = wrapper->model->createTagger();
        if (!wrapper->tagger)
        {
            rb_raise(rb_eRuntimeError, "Failed to create MeCab tagger: %s", MeCab::getLastError());
        }
    }

    VALUE segment_cut(VALUE self, VALUE text_rb_str)
    {
        std::string text = StringValueCStr(text_rb_str);

        SegmentWrapper *wrapper;
        TypedData_Get_Struct(self, SegmentWrapper, &segment_data_type, wrapper);

        VALUE surface = rb_ary_new();
        const MeCab::Node *node = wrapper->tagger->parseToNode(text.c_str());
        for (; node; node = node->next)
        {
            if (node->stat == MECAB_BOS_NODE || node->stat == MECAB_EOS_NODE)
            {
                continue;
            }

            rb_ary_push(surface, rb_enc_str_new(node->surface, node->length, utf8_encoding));
        }

        return surface;
    }
} // End of namespace ext_mecab

extern "C"
{
    void init_segment(VALUE rb_mMecab)
    {
        // Initialize UTF-8 encoding
        ext_mecab::utf8_encoding = rb_utf8_encoding();

        VALUE cSegment = rb_define_class_under(rb_mMecab, "Segment", rb_cObject);

        rb_define_alloc_func(cSegment, ext_mecab::segment_alloc);
        rb_define_method(cSegment, "_initialize", RUBY_METHOD_FUNC(ext_mecab::segment_initialize), 1);
        rb_define_method(cSegment, "_cut", RUBY_METHOD_FUNC(ext_mecab::segment_cut), 1);
    }
} // End of extern "C"
