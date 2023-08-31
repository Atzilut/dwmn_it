#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/nord

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  if [[ $cpu_val > 2.5 ]]; then
    printf "^c$red^"
    printf "^c$red^$cpu_val""GHz"
  elif [[ $cpu_val > 1.75 ]] && [[ $cpu_val < 2.5 ]]; then
    printf "^c$orange^"
    printf "^c$orange^$cpu_val""GHz"
  elif [[  $cpu_val > 1.0 ]] && [[ $cpu_val < 1.75  ]]; then
    printf "^c$yellow^"
    printf "^c$yellow^$cpu_val""GHz"
  else 
    printf "^c$green^"
    printf "^c$green^$cpu_val""GHz"
  fi
}

pkg_updates() {
  #updates=$({ timeout 20 doas xbps-install -un 2>/dev/null || true; } | wc -l) # void
  #updates=$({ timeout 20 checkupdates 2>/dev/null || true; } | wc -l) # arch
   updates=$(cat /var/lib/update-notifier/updates-available | grep "updates can be applied immediately" | awk '{print $1}')  # apt (ubuntu, debian etc)

  if [ $updates == 0 ]; then
    printf "  ^c$white^   󰏖"
  else
    printf "  ^c$white^   $updates"
  fi
}

battery() {
  bat_state=$(upower -i `upower -e | grep 'BAT'` | grep state: | awk '{print $2}')
  bat_val="$(cat /sys/class/power_supply/BAT1/capacity)"

  if [ $bat_state = "fully-charged" ]; then
    printf "^c$green^󰠠"
  elif [ $bat_state = "discharging" ]; then
    if (( $bat_val <= 20 )); then
      printf "^c$red^$bat_val"
    elif (( $bat_val > 20 )) && (( $bat_val <= 50 )); then
      printf "^c$orange^$bat_val"
    elif (( $bat_val > 50 && $bat_val <= 75)); then
      printf "^c$yellow^$bat_val"
    elif (($bat_val > 75 && $bat_val < 90)); then
      printf "^c$green^$bat_val"
    else 
      printf "^c$blue^$bat_val"
    fi
  elif [ $bat_state = "charging" ]; then
    #printf "^b$green^^c$black^󰠠"
    #printf "^c$green^^b$black^$bat_val"
    #printf "^c$green^ 󱐋$bat_val"
    printf "^c$green^$bat_val"

  else
    printf "^c$white^unknown battery status" 
  fi
}

brightness() {
  printf "^c$yellow^"
  bright=$(xbacklight | awk '{print substr($0,1)}' | cut -d'.' -f 1)
  printf "^c$yellow^%.0f\n" $bright 
}

mem() {
#  printf "^c$purple^^b$black^  "
  printf "^c$purple^"
  printf "^c$purple^$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)b"
}

disk() {
  printf "^c$teal^"
  printf '%s\n' "^c$teal^$(df | grep "/$" | awk '{ print $5 }' | sed s/%//g)%"
}

vol() {
  mute_val=$(pulsemixer --get-mute)
  vol_val=$(pulsemixer --get-volume | awk '{ print $1 }') 
  if [[   $mute_val == 1 ]] ; then
    printf "^$white^󰖁"
  elif [[   $mute_val == 0 ]]; then
    if  (( $vol_val > 80 )); then
      printf "^$white^󰕾"
      printf '%s\n' "^c$white^$(pulsemixer --get-volume | awk '{ print $1 }')%" 
    elif (( $vol_val < 80 )) && (( $vol_val > 50 )); then
      printf "^$white^󰖀"
      printf '%s\n' "^c$white^$(pulsemixer --get-volume | awk '{ print $1 }')%" 
    elif (( $vol_val < 50 )) && (( $vol_val > 0 )); then
      printf "^$white^󰕿"
      printf '%s\n' "^c$white^$(pulsemixer --get-volume | awk '{ print $1 }')%" 
    else
      printf "idk vol"
    fi
  else
    printf "idk mute"
  fi
}


wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$blue^󰤨^d^%s" ;;
  #up) printf "$(nmcli -c y d wifi | grep --color=yes "*" | awk '{print $3, $9}')" ;;
	down) printf "^c$blue^󰤭^d^%s" ;;
	esac
}

clock() {
	printf "^c$glacier^󱑆"
	printf "^c$glacier^$(date '+%H:%M%P')"
}

cal() {
  printf "^c$white^"
  printf "^c$white^$(date '+%D')"
}

while true; do

  #[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  #interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $(brightness) $(cpu) $(mem) $(disk) $(vol) $(wlan) $(battery) $(clock) $(cal)";
done
