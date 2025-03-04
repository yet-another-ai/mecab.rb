#include <ruby.h>

#include <mecab.h>

#include "segment.h"

RUBY_FUNC_EXPORTED void
Init_mecab(void)
{
  VALUE rb_mMecab = rb_define_module("Mecab");
  rb_define_const(rb_mMecab, "CPP_VERSION", rb_str_new2(mecab_version()));

  init_segment(rb_mMecab);
}
