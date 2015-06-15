srcdir = /var/www/learn/swoole-src
builddir = /var/www/learn/swoole-src
top_srcdir = /var/www/learn/swoole-src
top_builddir = /var/www/learn/swoole-src
EGREP = /bin/grep -E
SED = /bin/sed
CONFIGURE_COMMAND = './configure'
CONFIGURE_OPTIONS =
SHLIB_SUFFIX_NAME = so
SHLIB_DL_SUFFIX_NAME = so
ZEND_EXT_TYPE = zend_extension
RE2C = exit 0;
AWK = nawk
SWOOLE_SHARED_LIBADD = -lz -lrt
shared_objects_swoole = swoole.lo swoole_server.lo swoole_lock.lo swoole_client.lo swoole_event.lo swoole_timer.lo swoole_async.lo swoole_process.lo swoole_buffer.lo swoole_table.lo swoole_http.lo swoole_websocket.lo swoole_phpng.lo src/core/base.lo src/core/log.lo src/core/hashmap.lo src/core/RingQueue.lo src/core/Channel.lo src/core/string.lo src/core/array.lo src/core/socket.lo src/memory/ShareMemory.lo src/memory/MemoryGlobal.lo src/memory/RingBuffer.lo src/memory/FixedPool.lo src/memory/Malloc.lo src/memory/Table.lo src/memory/Buffer.lo src/factory/Factory.lo src/factory/FactoryThread.lo src/factory/FactoryProcess.lo src/reactor/ReactorBase.lo src/reactor/ReactorSelect.lo src/reactor/ReactorPoll.lo src/reactor/ReactorEpoll.lo src/reactor/ReactorKqueue.lo src/pipe/PipeBase.lo src/pipe/PipeEventfd.lo src/pipe/PipeUnsock.lo src/queue/Msg.lo src/lock/Semaphore.lo src/lock/Mutex.lo src/lock/RWLock.lo src/lock/SpinLock.lo src/lock/FileLock.lo src/network/Server.lo src/network/TaskWorker.lo src/network/Client.lo src/network/Connection.lo src/network/ProcessPool.lo src/network/ThreadPool.lo src/network/ReactorThread.lo src/network/ReactorProcess.lo src/network/Worker.lo src/network/EventTimer.lo src/os/base.lo src/os/linux_aio.lo src/os/gcc_aio.lo src/os/sendfile.lo src/os/signal.lo src/os/timer.lo src/protocol/Base.lo src/protocol/SSL.lo src/protocol/Http.lo src/protocol/WebSocket.lo src/protocol/Mqtt.lo src/protocol/Base64.lo thirdparty/php_http_parser.lo thirdparty/multipart_parser.lo
PHP_PECL_EXTENSION = swoole
PHP_MODULES = $(phplibdir)/swoole.la
PHP_ZEND_EX =
all_targets = $(PHP_MODULES) $(PHP_ZEND_EX)
install_targets = install-modules install-headers
prefix = /usr
exec_prefix = $(prefix)
libdir = ${exec_prefix}/lib
prefix = /usr
phplibdir = /var/www/learn/swoole-src/modules
phpincludedir = /usr/include/php5
CC = cc
CFLAGS = -Wall -pthread -g -O2
CFLAGS_CLEAN = $(CFLAGS)
CPP = cc -E
CPPFLAGS = -DHAVE_CONFIG_H
CXX =
CXXFLAGS =
CXXFLAGS_CLEAN = $(CXXFLAGS)
EXTENSION_DIR = /usr/lib/php5/20121212
PHP_EXECUTABLE = /usr/bin/php
EXTRA_LDFLAGS =
EXTRA_LIBS =
INCLUDES = -I/usr/include/php5 -I/usr/include/php5/main -I/usr/include/php5/TSRM -I/usr/include/php5/Zend -I/usr/include/php5/ext -I/usr/include/php5/ext/date/lib -I/var/www/learn/swoole-src/include
LFLAGS =
LDFLAGS = -lpthread
SHARED_LIBTOOL =
LIBTOOL = $(SHELL) $(top_builddir)/libtool
SHELL = /bin/bash
INSTALL_HEADERS =
mkinstalldirs = $(top_srcdir)/build/shtool mkdir -p
INSTALL = $(top_srcdir)/build/shtool install -c
INSTALL_DATA = $(INSTALL) -m 644

DEFS = -DPHP_ATOM_INC -I$(top_builddir)/include -I$(top_builddir)/main -I$(top_srcdir)
COMMON_FLAGS = $(DEFS) $(INCLUDES) $(EXTRA_INCLUDES) $(CPPFLAGS) $(PHP_FRAMEWORKPATH)

all: $(all_targets) 
	@echo
	@echo "Build complete."
	@echo "Don't forget to run 'make test'."
	@echo

build-modules: $(PHP_MODULES) $(PHP_ZEND_EX)

build-binaries: $(PHP_BINARIES)

libphp$(PHP_MAJOR_VERSION).la: $(PHP_GLOBAL_OBJS) $(PHP_SAPI_OBJS)
	$(LIBTOOL) --mode=link $(CC) $(CFLAGS) $(EXTRA_CFLAGS) -rpath $(phptempdir) $(EXTRA_LDFLAGS) $(LDFLAGS) $(PHP_RPATHS) $(PHP_GLOBAL_OBJS) $(PHP_SAPI_OBJS) $(EXTRA_LIBS) $(ZEND_EXTRA_LIBS) -o $@
	-@$(LIBTOOL) --silent --mode=install cp $@ $(phptempdir)/$@ >/dev/null 2>&1

libs/libphp$(PHP_MAJOR_VERSION).bundle: $(PHP_GLOBAL_OBJS) $(PHP_SAPI_OBJS)
	$(CC) $(MH_BUNDLE_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS) $(LDFLAGS) $(EXTRA_LDFLAGS) $(PHP_GLOBAL_OBJS:.lo=.o) $(PHP_SAPI_OBJS:.lo=.o) $(PHP_FRAMEWORKS) $(EXTRA_LIBS) $(ZEND_EXTRA_LIBS) -o $@ && cp $@ libs/libphp$(PHP_MAJOR_VERSION).so

install: $(all_targets) $(install_targets)

install-sapi: $(OVERALL_TARGET)
	@echo "Installing PHP SAPI module:       $(PHP_SAPI)"
	-@$(mkinstalldirs) $(INSTALL_ROOT)$(bindir)
	-@if test ! -r $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME); then \
		for i in 0.0.0 0.0 0; do \
			if test -r $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME).$$i; then \
				$(LN_S) $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME).$$i $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME); \
				break; \
			fi; \
		done; \
	fi
	@$(INSTALL_IT)

install-binaries: build-binaries $(install_binary_targets)

install-modules: build-modules
	@test -d modules && \
	$(mkinstalldirs) $(INSTALL_ROOT)$(EXTENSION_DIR)
	@echo "Installing shared extensions:     $(INSTALL_ROOT)$(EXTENSION_DIR)/"
	@rm -f modules/*.la >/dev/null 2>&1
	@$(INSTALL) modules/* $(INSTALL_ROOT)$(EXTENSION_DIR)

install-headers:
	-@if test "$(INSTALL_HEADERS)"; then \
		for i in `echo $(INSTALL_HEADERS)`; do \
			i=`$(top_srcdir)/build/shtool path -d $$i`; \
			paths="$$paths $(INSTALL_ROOT)$(phpincludedir)/$$i"; \
		done; \
		$(mkinstalldirs) $$paths && \
		echo "Installing header files:          $(INSTALL_ROOT)$(phpincludedir)/" && \
		for i in `echo $(INSTALL_HEADERS)`; do \
			if test "$(PHP_PECL_EXTENSION)"; then \
				src=`echo $$i | $(SED) -e "s#ext/$(PHP_PECL_EXTENSION)/##g"`; \
			else \
				src=$$i; \
			fi; \
			if test -f "$(top_srcdir)/$$src"; then \
				$(INSTALL_DATA) $(top_srcdir)/$$src $(INSTALL_ROOT)$(phpincludedir)/$$i; \
			elif test -f "$(top_builddir)/$$src"; then \
				$(INSTALL_DATA) $(top_builddir)/$$src $(INSTALL_ROOT)$(phpincludedir)/$$i; \
			else \
				(cd $(top_srcdir)/$$src && $(INSTALL_DATA) *.h $(INSTALL_ROOT)$(phpincludedir)/$$i; \
				cd $(top_builddir)/$$src && $(INSTALL_DATA) *.h $(INSTALL_ROOT)$(phpincludedir)/$$i) 2>/dev/null || true; \
			fi \
		done; \
	fi

PHP_TEST_SETTINGS = -d 'open_basedir=' -d 'output_buffering=0' -d 'memory_limit=-1'
PHP_TEST_SHARED_EXTENSIONS =  ` \
	if test "x$(PHP_MODULES)" != "x"; then \
		for i in $(PHP_MODULES)""; do \
			. $$i; $(top_srcdir)/build/shtool echo -n -- " -d extension=$$dlname"; \
		done; \
	fi; \
	if test "x$(PHP_ZEND_EX)" != "x"; then \
		for i in $(PHP_ZEND_EX)""; do \
			. $$i; $(top_srcdir)/build/shtool echo -n -- " -d $(ZEND_EXT_TYPE)=$(top_builddir)/modules/$$dlname"; \
		done; \
	fi`
PHP_DEPRECATED_DIRECTIVES_REGEX = '^(magic_quotes_(gpc|runtime|sybase)?|(zend_)?extension(_debug)?(_ts)?)[\t\ ]*='

test: all
	@if test ! -z "$(PHP_EXECUTABLE)" && test -x "$(PHP_EXECUTABLE)"; then \
		INI_FILE=`$(PHP_EXECUTABLE) -d 'display_errors=stderr' -r 'echo php_ini_loaded_file();' 2> /dev/null`; \
		if test "$$INI_FILE"; then \
			$(EGREP) -h -v $(PHP_DEPRECATED_DIRECTIVES_REGEX) "$$INI_FILE" > $(top_builddir)/tmp-php.ini; \
		else \
			echo > $(top_builddir)/tmp-php.ini; \
		fi; \
		INI_SCANNED_PATH=`$(PHP_EXECUTABLE) -d 'display_errors=stderr' -r '$$a = explode(",\n", trim(php_ini_scanned_files())); echo $$a[0];' 2> /dev/null`; \
		if test "$$INI_SCANNED_PATH"; then \
			INI_SCANNED_PATH=`$(top_srcdir)/build/shtool path -d $$INI_SCANNED_PATH`; \
			$(EGREP) -h -v $(PHP_DEPRECATED_DIRECTIVES_REGEX) "$$INI_SCANNED_PATH"/*.ini >> $(top_builddir)/tmp-php.ini; \
		fi; \
		TEST_PHP_EXECUTABLE=$(PHP_EXECUTABLE) \
		TEST_PHP_SRCDIR=$(top_srcdir) \
		CC="$(CC)" \
			$(PHP_EXECUTABLE) -n -c $(top_builddir)/tmp-php.ini $(PHP_TEST_SETTINGS) $(top_srcdir)/run-tests.php -n -c $(top_builddir)/tmp-php.ini -d extension_dir=$(top_builddir)/modules/ $(PHP_TEST_SHARED_EXTENSIONS) $(TESTS); \
		TEST_RESULT_EXIT_CODE=$$?; \
		rm $(top_builddir)/tmp-php.ini; \
		exit $$TEST_RESULT_EXIT_CODE; \
	else \
		echo "ERROR: Cannot run tests without CLI sapi."; \
	fi

clean:
	find . -name \*.gcno -o -name \*.gcda | xargs rm -f
	find . -name \*.lo -o -name \*.o | xargs rm -f
	find . -name \*.la -o -name \*.a | xargs rm -f 
	find . -name \*.so | xargs rm -f
	find . -name .libs -a -type d|xargs rm -rf
	rm -f libphp$(PHP_MAJOR_VERSION).la $(SAPI_CLI_PATH) $(SAPI_CGI_PATH) $(SAPI_MILTER_PATH) $(SAPI_LITESPEED_PATH) $(SAPI_FPM_PATH) $(OVERALL_TARGET) modules/* libs/*

distclean: clean
	rm -f Makefile config.cache config.log config.status Makefile.objects Makefile.fragments libtool main/php_config.h main/internal_functions_cli.c main/internal_functions.c stamp-h sapi/apache/libphp$(PHP_MAJOR_VERSION).module sapi/apache_hooks/libphp$(PHP_MAJOR_VERSION).module buildmk.stamp Zend/zend_dtrace_gen.h Zend/zend_dtrace_gen.h.bak Zend/zend_config.h TSRM/tsrm_config.h
	rm -f php5.spec main/build-defs.h scripts/phpize
	rm -f ext/date/lib/timelib_config.h ext/mbstring/oniguruma/config.h ext/mbstring/libmbfl/config.h ext/mysqlnd/php_mysqlnd_config.h
	rm -f scripts/man1/phpize.1 scripts/php-config scripts/man1/php-config.1 sapi/cli/php.1 sapi/cgi/php-cgi.1 ext/phar/phar.1 ext/phar/phar.phar.1
	rm -f sapi/fpm/php-fpm.conf sapi/fpm/init.d.php-fpm sapi/fpm/php-fpm.service sapi/fpm/php-fpm.8 sapi/fpm/status.html
	rm -f ext/iconv/php_have_bsd_iconv.h ext/iconv/php_have_glibc_iconv.h ext/iconv/php_have_ibm_iconv.h ext/iconv/php_have_iconv.h ext/iconv/php_have_libiconv.h ext/iconv/php_iconv_aliased_libiconv.h ext/iconv/php_iconv_supports_errno.h ext/iconv/php_php_iconv_h_path.h ext/iconv/php_php_iconv_impl.h
	rm -f ext/phar/phar.phar ext/phar/phar.php
	if test "$(srcdir)" != "$(builddir)"; then \
	  rm -f ext/phar/phar/phar.inc; \
	fi
	$(EGREP) define'.*include/php' $(top_srcdir)/configure | $(SED) 's/.*>//'|xargs rm -f

.PHONY: all clean install distclean test
.NOEXPORT:
swoole.lo: /var/www/learn/swoole-src/swoole.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole.c -o swoole.lo 
swoole_server.lo: /var/www/learn/swoole-src/swoole_server.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_server.c -o swoole_server.lo 
swoole_lock.lo: /var/www/learn/swoole-src/swoole_lock.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_lock.c -o swoole_lock.lo 
swoole_client.lo: /var/www/learn/swoole-src/swoole_client.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_client.c -o swoole_client.lo 
swoole_event.lo: /var/www/learn/swoole-src/swoole_event.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_event.c -o swoole_event.lo 
swoole_timer.lo: /var/www/learn/swoole-src/swoole_timer.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_timer.c -o swoole_timer.lo 
swoole_async.lo: /var/www/learn/swoole-src/swoole_async.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_async.c -o swoole_async.lo 
swoole_process.lo: /var/www/learn/swoole-src/swoole_process.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_process.c -o swoole_process.lo 
swoole_buffer.lo: /var/www/learn/swoole-src/swoole_buffer.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_buffer.c -o swoole_buffer.lo 
swoole_table.lo: /var/www/learn/swoole-src/swoole_table.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_table.c -o swoole_table.lo 
swoole_http.lo: /var/www/learn/swoole-src/swoole_http.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_http.c -o swoole_http.lo 
swoole_websocket.lo: /var/www/learn/swoole-src/swoole_websocket.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_websocket.c -o swoole_websocket.lo 
swoole_phpng.lo: /var/www/learn/swoole-src/swoole_phpng.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/swoole_phpng.c -o swoole_phpng.lo 
src/core/base.lo: /var/www/learn/swoole-src/src/core/base.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/core/base.c -o src/core/base.lo 
src/core/log.lo: /var/www/learn/swoole-src/src/core/log.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/core/log.c -o src/core/log.lo 
src/core/hashmap.lo: /var/www/learn/swoole-src/src/core/hashmap.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/core/hashmap.c -o src/core/hashmap.lo 
src/core/RingQueue.lo: /var/www/learn/swoole-src/src/core/RingQueue.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/core/RingQueue.c -o src/core/RingQueue.lo 
src/core/Channel.lo: /var/www/learn/swoole-src/src/core/Channel.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/core/Channel.c -o src/core/Channel.lo 
src/core/string.lo: /var/www/learn/swoole-src/src/core/string.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/core/string.c -o src/core/string.lo 
src/core/array.lo: /var/www/learn/swoole-src/src/core/array.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/core/array.c -o src/core/array.lo 
src/core/socket.lo: /var/www/learn/swoole-src/src/core/socket.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/core/socket.c -o src/core/socket.lo 
src/memory/ShareMemory.lo: /var/www/learn/swoole-src/src/memory/ShareMemory.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/memory/ShareMemory.c -o src/memory/ShareMemory.lo 
src/memory/MemoryGlobal.lo: /var/www/learn/swoole-src/src/memory/MemoryGlobal.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/memory/MemoryGlobal.c -o src/memory/MemoryGlobal.lo 
src/memory/RingBuffer.lo: /var/www/learn/swoole-src/src/memory/RingBuffer.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/memory/RingBuffer.c -o src/memory/RingBuffer.lo 
src/memory/FixedPool.lo: /var/www/learn/swoole-src/src/memory/FixedPool.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/memory/FixedPool.c -o src/memory/FixedPool.lo 
src/memory/Malloc.lo: /var/www/learn/swoole-src/src/memory/Malloc.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/memory/Malloc.c -o src/memory/Malloc.lo 
src/memory/Table.lo: /var/www/learn/swoole-src/src/memory/Table.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/memory/Table.c -o src/memory/Table.lo 
src/memory/Buffer.lo: /var/www/learn/swoole-src/src/memory/Buffer.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/memory/Buffer.c -o src/memory/Buffer.lo 
src/factory/Factory.lo: /var/www/learn/swoole-src/src/factory/Factory.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/factory/Factory.c -o src/factory/Factory.lo 
src/factory/FactoryThread.lo: /var/www/learn/swoole-src/src/factory/FactoryThread.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/factory/FactoryThread.c -o src/factory/FactoryThread.lo 
src/factory/FactoryProcess.lo: /var/www/learn/swoole-src/src/factory/FactoryProcess.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/factory/FactoryProcess.c -o src/factory/FactoryProcess.lo 
src/reactor/ReactorBase.lo: /var/www/learn/swoole-src/src/reactor/ReactorBase.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/reactor/ReactorBase.c -o src/reactor/ReactorBase.lo 
src/reactor/ReactorSelect.lo: /var/www/learn/swoole-src/src/reactor/ReactorSelect.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/reactor/ReactorSelect.c -o src/reactor/ReactorSelect.lo 
src/reactor/ReactorPoll.lo: /var/www/learn/swoole-src/src/reactor/ReactorPoll.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/reactor/ReactorPoll.c -o src/reactor/ReactorPoll.lo 
src/reactor/ReactorEpoll.lo: /var/www/learn/swoole-src/src/reactor/ReactorEpoll.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/reactor/ReactorEpoll.c -o src/reactor/ReactorEpoll.lo 
src/reactor/ReactorKqueue.lo: /var/www/learn/swoole-src/src/reactor/ReactorKqueue.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/reactor/ReactorKqueue.c -o src/reactor/ReactorKqueue.lo 
src/pipe/PipeBase.lo: /var/www/learn/swoole-src/src/pipe/PipeBase.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/pipe/PipeBase.c -o src/pipe/PipeBase.lo 
src/pipe/PipeEventfd.lo: /var/www/learn/swoole-src/src/pipe/PipeEventfd.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/pipe/PipeEventfd.c -o src/pipe/PipeEventfd.lo 
src/pipe/PipeUnsock.lo: /var/www/learn/swoole-src/src/pipe/PipeUnsock.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/pipe/PipeUnsock.c -o src/pipe/PipeUnsock.lo 
src/queue/Msg.lo: /var/www/learn/swoole-src/src/queue/Msg.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/queue/Msg.c -o src/queue/Msg.lo 
src/lock/Semaphore.lo: /var/www/learn/swoole-src/src/lock/Semaphore.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/lock/Semaphore.c -o src/lock/Semaphore.lo 
src/lock/Mutex.lo: /var/www/learn/swoole-src/src/lock/Mutex.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/lock/Mutex.c -o src/lock/Mutex.lo 
src/lock/RWLock.lo: /var/www/learn/swoole-src/src/lock/RWLock.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/lock/RWLock.c -o src/lock/RWLock.lo 
src/lock/SpinLock.lo: /var/www/learn/swoole-src/src/lock/SpinLock.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/lock/SpinLock.c -o src/lock/SpinLock.lo 
src/lock/FileLock.lo: /var/www/learn/swoole-src/src/lock/FileLock.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/lock/FileLock.c -o src/lock/FileLock.lo 
src/network/Server.lo: /var/www/learn/swoole-src/src/network/Server.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/network/Server.c -o src/network/Server.lo 
src/network/TaskWorker.lo: /var/www/learn/swoole-src/src/network/TaskWorker.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/network/TaskWorker.c -o src/network/TaskWorker.lo 
src/network/Client.lo: /var/www/learn/swoole-src/src/network/Client.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/network/Client.c -o src/network/Client.lo 
src/network/Connection.lo: /var/www/learn/swoole-src/src/network/Connection.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/network/Connection.c -o src/network/Connection.lo 
src/network/ProcessPool.lo: /var/www/learn/swoole-src/src/network/ProcessPool.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/network/ProcessPool.c -o src/network/ProcessPool.lo 
src/network/ThreadPool.lo: /var/www/learn/swoole-src/src/network/ThreadPool.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/network/ThreadPool.c -o src/network/ThreadPool.lo 
src/network/ReactorThread.lo: /var/www/learn/swoole-src/src/network/ReactorThread.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/network/ReactorThread.c -o src/network/ReactorThread.lo 
src/network/ReactorProcess.lo: /var/www/learn/swoole-src/src/network/ReactorProcess.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/network/ReactorProcess.c -o src/network/ReactorProcess.lo 
src/network/Worker.lo: /var/www/learn/swoole-src/src/network/Worker.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/network/Worker.c -o src/network/Worker.lo 
src/network/EventTimer.lo: /var/www/learn/swoole-src/src/network/EventTimer.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/network/EventTimer.c -o src/network/EventTimer.lo 
src/os/base.lo: /var/www/learn/swoole-src/src/os/base.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/os/base.c -o src/os/base.lo 
src/os/linux_aio.lo: /var/www/learn/swoole-src/src/os/linux_aio.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/os/linux_aio.c -o src/os/linux_aio.lo 
src/os/gcc_aio.lo: /var/www/learn/swoole-src/src/os/gcc_aio.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/os/gcc_aio.c -o src/os/gcc_aio.lo 
src/os/sendfile.lo: /var/www/learn/swoole-src/src/os/sendfile.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/os/sendfile.c -o src/os/sendfile.lo 
src/os/signal.lo: /var/www/learn/swoole-src/src/os/signal.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/os/signal.c -o src/os/signal.lo 
src/os/timer.lo: /var/www/learn/swoole-src/src/os/timer.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/os/timer.c -o src/os/timer.lo 
src/protocol/Base.lo: /var/www/learn/swoole-src/src/protocol/Base.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/protocol/Base.c -o src/protocol/Base.lo 
src/protocol/SSL.lo: /var/www/learn/swoole-src/src/protocol/SSL.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/protocol/SSL.c -o src/protocol/SSL.lo 
src/protocol/Http.lo: /var/www/learn/swoole-src/src/protocol/Http.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/protocol/Http.c -o src/protocol/Http.lo 
src/protocol/WebSocket.lo: /var/www/learn/swoole-src/src/protocol/WebSocket.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/protocol/WebSocket.c -o src/protocol/WebSocket.lo 
src/protocol/Mqtt.lo: /var/www/learn/swoole-src/src/protocol/Mqtt.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/protocol/Mqtt.c -o src/protocol/Mqtt.lo 
src/protocol/Base64.lo: /var/www/learn/swoole-src/src/protocol/Base64.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/src/protocol/Base64.c -o src/protocol/Base64.lo 
thirdparty/php_http_parser.lo: /var/www/learn/swoole-src/thirdparty/php_http_parser.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/thirdparty/php_http_parser.c -o thirdparty/php_http_parser.lo 
thirdparty/multipart_parser.lo: /var/www/learn/swoole-src/thirdparty/multipart_parser.c
	$(LIBTOOL) --mode=compile $(CC)  -I. -I/var/www/learn/swoole-src $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /var/www/learn/swoole-src/thirdparty/multipart_parser.c -o thirdparty/multipart_parser.lo 
$(phplibdir)/swoole.la: ./swoole.la
	$(LIBTOOL) --mode=install cp ./swoole.la $(phplibdir)

./swoole.la: $(shared_objects_swoole) $(SWOOLE_SHARED_DEPENDENCIES)
	$(LIBTOOL) --mode=link $(CC) $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS) $(LDFLAGS) -o $@ -export-dynamic -avoid-version -prefer-pic -module -rpath $(phplibdir) $(EXTRA_LDFLAGS) $(shared_objects_swoole) $(SWOOLE_SHARED_LIBADD)

