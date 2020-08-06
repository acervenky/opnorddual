RUNONCE=true

patch_mixer_toplevel() {
  case $1 in
    -c) if [ "$(grep "<ctl name=\"$2\" value=\".*\" />" $MODPATH/system/vendor/etc/mixer_paths.xml)" ]; then
          local num=$(sed -n "/<ctl name=\"$2\" value=\".*\" \/>/=" $MODPATH/system/vendor/etc/mixer_paths.xml | head -n1)
          sed -i "$num s/\(<ctl name=\"$2\" value=\"\).*\(\" \/>\)/\1$3\2/" $MODPATH/system/vendor/etc/mixer_paths.xml
        fi;;
    -p) if [ "$(sed -n "/ *<path name=\"$2\">/,/ *<\/path>/ {/<ctl name=\"$3\" value=\".*\" \/>/p}" $MODPATH/system/vendor/etc/mixer_paths.xml)" ]; then
          sed -i "/ *<path name=\"$2\">/,/ *<\/path>/ s/\(<ctl name=\"$3\" value=\".*\" \/>\)/\1\n        <ctl name=\"$4\" value=\"$5\" \/>/" $MODPATH/system/vendor/etc/mixer_paths.xml
        fi;;
  esac
}

patch_mixer_toplevel -c "WSA RX1 MUX" "AIF1_PB"
patch_mixer_toplevel -c "RX INT0_1 MIX1 INP0" "RX0"
sed -i "/ *<path name=\"deep-buffer-playback\">/a\      <ctl name=\"RX_CDC_DMA_RX_0 Audio Mixer MultiMedia1\" value=\"1\" \/>" $MODPATH/system/vendor/etc/mixer_paths.xml
sed -i "/ *<path name=\"low-latency-playback\">/a\      <ctl name=\"RX_CDC_DMA_RX_0 Audio Mixer MultiMedia5\" value=\"1\" \/>" $MODPATH/system/vendor/etc/mixer_paths.xml
sed -i "/ *<path name=\"compress-offload-playback\">/a\      <ctl name=\"RX_CDC_DMA_RX_0 Audio Mixer MultiMedia4\" value=\"1\" \/>" $MODPATH/system/vendor/etc/mixer_paths.xml
