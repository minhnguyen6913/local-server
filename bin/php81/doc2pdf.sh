# export HOME=/tmp && soffice --headless --convert-to pdf --outdir $1 $2
export HOME=/tmp && soffice --headless --convert-to pdf --outdir $1  --convert-options "EmbedFonts=true" --infilter="Microsoft Word 2007-2013 XML" $2

