help:
    @just --list

install:
    rm -rf libs
    jresolve --output-directory libs @libs.txt

clean:
    rm -rf build

compile: clean
    javac \
        -d build/javac \
        --module-path libs \
        --module-source-path "./*/src" \
        --module web.hello,web.util,web.hello.test,web.util.test

package: compile
    jar --create \
        --file build/jar/web.hello.jar \
        --main-class web.hello.Application \
        -C web.hello/res . \
        -C build/javac/web.hello .

    jar --create \
        --file build/jar/web.util.jar \
        -C build/javac/web.util .

    jar --create \
        --file build/jar/web.hello.test.jar \
        -C build/javac/web.hello.test .

    jar --create \
        --file build/jar/web.util.test.jar \
        -C build/javac/web.util.test .

run: package
    java --module-path libs:build/jar --module web.hello

document:
    javadoc \
        -d build/javadoc \
        --module-path libs \
        --module-source-path "./*/src" \
        --module web.hello,web.util

test: package
    java \
        --module-path libs:build/jar \
        --add-modules web.hello.test,web.util.test \
        --module org.junit.platform.console \
        execute \
          --select-module web.hello.test \
          --select-module web.util.test \
          --reports-dir build/junit