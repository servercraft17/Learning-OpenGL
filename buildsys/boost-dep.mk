boost_dir = $(ext_dir_path)/boost

ifeq ($(OS),Windows_NT)
BOOST_URL = https://archives.boost.io/release/1.82.0/source/boost_1_82_0.zip
else
BOOST_URL = https://archives.boost.io/release/1.82.0/source/boost_1_82_0.tar.bz2
endif

BOOST_ARCHIVE = $(notdir $(BOOST_URL))

./$(ext_dir)/boost:
	$(call mkdir,$(boost_dir))
	$(call ifnex,$(boost_dir)/$(BOOST_ARCHIVE),cd $(call fixslash,$(boost_dir)) && wget $(BOOST_URL))
	cd $(call fixslash,$(boost_dir)) && tar -xf $(BOOST_ARCHIVE) $(basename $(basename $(BOOST_ARCHIVE)))/ -C . --strip-components=1

.PHONY: clean_boost
clean_boost:
	$(call rmrf,$(boost_dir))

boost_dep = ./$(ext_dir)/boost
boost_include = -I $(ext_dir)/boost
boost_clean = $(clean_boost)
clean_list+=$(boost_clean)
dep_list += $(boost_dep)
inc += $(boost_include)