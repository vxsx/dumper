# Dumper

Small component for making Data::Dumper output more usable

1. `[% INCLUDE 'dumper.html.tt %]`
2. Integrate `_dumper.scss` and `dumper.coffee` any way you like
3. Go to `http://yoursite.com/?dump=1` of `?dump=list,of,variables`
4. ???
5. Profit!

# Initialization

Normally you don't have to do anything if you use template provided,
but in case you need to init it manually you do smth like this

```javascript
var elem = document.getElementById('my-dumper');
new Dumper(elem);
```
