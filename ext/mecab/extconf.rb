# frozen_string_literal: true

require "mkmf"

begin
  find_executable("mecab-config") or abort "mecab-config not found"
rescue SystemExit
  install_text = case RUBY_PLATFORM
                 when /linux/
                   "apt install libmecab-dev mecab-ipadic-utf8"
                 when /darwin/
                   "brew install mecab mecab-ipadic"
                 else
                   "We don't know how to install mecab on your platform"
                 end

  abort <<~MSG
    mecab is missing. You can install it by running:
    #{install_text}
  MSG
end

mecab_config = with_config("mecab-config", "mecab-config")
enable_config("mecab-config")

append_cflags("-fvisibility=hidden -std=c11 -O3 -g")
append_cflags(`#{mecab_config} --cflags`.chomp)

append_cppflags("-fvisibility=hidden -std=c++11 -O3 -g")
append_cppflags(`#{mecab_config} --cflags`.chomp)

append_ldflags(`#{mecab_config} --libs`.chomp)

includes = [RbConfig::CONFIG["includedir"]]
includes += `#{mecab_config} --inc-dir`.chomp.split
libs = [RbConfig::CONFIG["libdir"]]
dir_config("mecab", includes, libs)

create_makefile("mecab/mecab")
