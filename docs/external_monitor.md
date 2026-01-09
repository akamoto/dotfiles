## xrandr

### scale for different resolution screen
```
xrandr \
  --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal \
  --output DP1 --mode 1920x1200 --pos 3840x0 --rotate normal --scale 2x2 \
```

