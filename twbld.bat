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

rem tiddlywiki %TMP_DIR% --render [all[]] %HTML_INDEX_FILE% text/plain $:/core/templates/alltiddlers.template.html


rem ENDLOCAL



It has almost for sure been established that the TW5 command `rendertiddler` (as well as `render`) generates non-empty content `undefined` in a single-file HTML wiki for `_canonical_uri` tiddlers. 

For instance, now the HTML-code of a tiddler `my-image.png` looks like:

	<div _canonical_uri="./images/my-image.png" title="my-image.png" type="image/png" revision="0" bag="default">
	<pre>undefined</pre>
	</div>

Whereas earlier (at least a couple of weeks ago) it looked like:

	<div _canonical_uri="./images/my-image.png" title="my-image.png" type="image/png" revision="0" bag="default">
	<pre></pre>
	</div>

As a result the TW does not reveal the image correctly - it looks like a broken link image.

In order to solve this issue I was forced to temporarily apply the following js-patch (for removing the unwanted token `undefined`):

	let search_token = new RegExp("(<div[^>]+_canonical_uri[^>]+>[\\s\\r\\n]*<pre>)([^<>]+)(</pre>[\\s\\r\\n]*</div>)","gim");
	let replace_token = "$1$3";
	let s_html_code = fs.readFileSync(html_index_file,'utf8');
	let s_html_code_patched = s_html_code.replace(search_token, replace_token);
	fs.writeFileSync(html_index_file, s_html_code_patched);

The Node.js version used is 5.1.21, OS - Windows 10.

The command-line script used for building a single-file HTML wiki is as follows:

	xcopy /s/i/q %TW_DIR%\*.* %TMP_DIR%

	tiddlywiki %TMP_DIR% --savetiddlers %IMG_FILTER% %HTML_IMAGES_DIR%
	tiddlywiki %TMP_DIR% --setfield %IMG_FILTER% _canonical_uri "$:/core/templates/canonical-uri-external-image" text/plain
	tiddlywiki %TMP_DIR% --setfield %IMG_FILTER% text "" text/plain
	tiddlywiki %TMP_DIR% --rendertiddler $:/plugins/tiddlywiki/tiddlyweb/save/offline %HTML_INDEX_FILE% text/plain

The newest version of the rendering command gives the similar effect:

	tiddlywiki %TMP_DIR% --render [all[]] %HTML_INDEX_FILE% text/plain $:/core/templates/alltiddlers.template.html

My conclusion - that is a bug. 

I'd be grateful to the TW community for solving this issue.

Sincerely, Olegh