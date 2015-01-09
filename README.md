This is a tiny script to count request per time interval from an
Apache access log file and plot them using [Gnuplot](http://www.gnuplot.info).

You need Gnuplot installed and the [Gnuplot gem](https://rubygems.org/gems/gnuplot):
```
gem install gnuplot
```

The access log can either be piped into the script by `STDIN` or be supplied as
the first argument.
