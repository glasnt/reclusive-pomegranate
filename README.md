# A slightly better toolchain for quicker formatting of markdown for reveal.js things


`ruby preparse.rb input_file output_file`

# Tool Chain

 * Make a markdown file, e.g. `myslides.md`
 * Use these fancy shortcuts to extend the default functionality of the markdown format
 * run `ruby preparse.rb myslides.md`
  * defaults to standard out, or to the specifed file
 * require the `slides.md` in your `reveal.js` `index.html` file
 * customize your `data-markdown` options where appropriate

## Shortcuts

### Center `=`

If your default is `center: false`, then this adds `.slide: class="center"`

### Top `#`

If not using center, this automatically adds `margin-bottom` padding as to attempt to make your sides not rise like a hot-air balloon to the top of your deck

### Fragment `-`

Automatically adds `.element: class="fragment"`

### h0 `!#`

For when you need to make a point bigger than the point-size in a `h1`

Useful in combination with `center`. 

## Tips

Use [inotifyrun](http://exyr.org/2011/inotify-run/) to automatically run the parser whenever you update your slide file

`~/talks/mytalk $ inotifyrun ruby ~/git/adamant-capsicum/preparse.rb myslides.txt slides.md`


## Samples

* `index.html` - sample reveal.js index.html. [Use the most up to date library files](https://github.com/hakimel/reveal.js)
 * includes my defaults for making reveal not look like reveal (removing in screen navigation, etc)
* [`input.md`](https://raw.githubusercontent.com/glasnt/adamant-capsicum/master/sample_input.md) and [`output.md`](https://raw.githubusercontent.com/glasnt/adamant-capsicum/master/sample_output.md) - sample input, and the automatically generated output

# Usefulness

YMMV

# License

See [LICENSE](blob/master/LICENSE)
