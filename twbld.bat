rem TESTS OF _CANONICAL_URI TIDDLER ISSUE
rem SETLOCAL

SET TW_DIR="D:\boa_protw\wiki_bag\prosteer"
SET TMP_DIR="D:\boa_protw\_tmp\tmp_tw"
SET IMG_FILTER="[is[image]] -[prefix[$:/]]"
SET HTML_IMAGES_DIR="D:\boa_protw\wiki_bag\prosteer\docs\images"
SET HTML_INDEX_FILE="D:\boa_protw\wiki_bag\prosteer\docs\index.html"

xcopy /s/i/q %TW_DIR%\*.* %TMP_DIR%

tiddlywiki %TMP_DIR% --savetiddlers %IMG_FILTER% %HTML_IMAGES_DIR%
tiddlywiki %TMP_DIR% --setfield %IMG_FILTER% _canonical_uri "$:/core/templates/canonical-uri-external-image" text/plain
tiddlywiki %TMP_DIR% --setfield %IMG_FILTER% text "" text/plain
tiddlywiki %TMP_DIR% --rendertiddler $:/plugins/tiddlywiki/tiddlyweb/save/offline %HTML_INDEX_FILE% text/plain

rem ENDLOCAL
