#! /vendor/bin/sh

PATH=/vendor/bin

cat /sys/kernel/eos_if/fwdl

for file in /sys/class/input/input*; do
	name=`cat ${file}/name`
	case "${name}" in
		"sensor_com")
			chown system:system ${file}/fw_version_chk
			chown system:system ${file}/fw_version
			chown system:system ${file}/fw_update_sq
			;;
		"accelerometer")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/data
			chown system:system ${file}/host_cmd
			chown system:system ${file}/offset
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			chown system:system ${file}/auto_cal_offset
			;;
		"linear_acceleration")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/status
			chown system:system ${file}/data
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"gyroscope")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/data
			chown system:system ${file}/offset
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"gyroscope_uncalibrated")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/data
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"gravity")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/status
			chown system:system ${file}/data
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"geomagnetic")
			chown system:system ${file}/data
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/status
			chown system:system ${file}/filter_enable
			chown system:system ${file}/filter_len
			chown system:system ${file}/filter_noise
			chown system:system ${file}/filter_threshold
			chown system:system ${file}/position
			chown system:system ${file}/distortion
			chown system:system ${file}/dynamic_matrix
			chown system:system ${file}/ellipsoid_mode
			chown system:system ${file}/offsets
			chown system:system ${file}/shape
			chown system:system ${file}/static_matrix
			chown system:system ${file}/threshold
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"magnetic_field_uncalibrated")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/data
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"rotation_vector")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/status
			chown system:system ${file}/data
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"game_rotation_vector")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/data
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"geomagnetic_rotation_vector")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/data
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"orientation")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/status
			chown system:system ${file}/data
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"significant_motion")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			;;
		"step_counter")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/data
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data_2
			chown system:system ${file}/batch_data_1
			chown system:system ${file}/batch_data_status
			chown system:system ${file}/batch_data_abs
			;;
		"step_detector")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data_2
			chown system:system ${file}/batch_data_1
			chown system:system ${file}/batch_data_status
			chown system:system ${file}/batch_data_abs
			;;
		"device_orientation")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/flush
			;;
		"stationary_detect")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			;;
		"motion_detect")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			;;
		"sensor_ext")
			chown system:system ${file}/dailys_enable
			chown system:system ${file}/dailys_param
			chown system:system ${file}/dailys_pedo_data
			chown system:system ${file}/dailys_vehi_data
			chown system:system ${file}/dailys_iwifi_data
			chown system:system ${file}/dailys_iwifi_param
			chown system:system ${file}/dailys_clear
			chown system:system ${file}/dailys_rt_state
			chown system:system ${file}/dailys_vib_interlocking
			chown system:system ${file}/dailys_soundvib_prevention
			;;
		"light")
			chown system:system ${file}/enable
			chown system:system ${file}/flush
			chown system:system ${file}/prop
			;;
		"ps_sensor")
			chown system:system ${file}/enable
			chown system:system ${file}/flush
			chown system:system ${file}/prop
			chown system:system ${file}/thresh
			chown system:system ${file}/calib
			;;
		"gesture")
			chown system:system ${file}/enable_gs_sensor
			chown system:system ${file}/flush
			chown system:system ${file}/prop
			chown system:system ${file}/gs_calibration
			;;
		"vhdetect")
			chown system:system ${file}/vhdetect_enable
			chown system:system ${file}/vhdetect_data
			chown system:system ${file}/vhdetect_imit_data
			;;
		"kc_motion_sensor")
			chown system:system ${file}/kc_motion_bringup_data
			chown system:system ${file}/kc_motion_enable
			chown system:system ${file}/kc_motion_interrupt_kind
			chown system:system ${file}/kc_motion_vehi_data
			chown system:system ${file}/kc_motion_walk_data
			;;
		"cy8c20237_touch_key")
			chown system:system ${file}/charge_interlock
			chown system:system ${file}/esd_polling
			chown system:system ${file}/event_notice
			chown system:system ${file}/reg_read
			chown system:system ${file}/reg_write
			chown system:system ${file}/slide_onoff
			chown system:system ${file}/touch_button
			;;
		"pressure")
			chown system:system ${file}/delay
			chown system:system ${file}/enable
			chown system:system ${file}/data
			chown system:system ${file}/offset
			chown system:system ${file}/batch
			chown system:system ${file}/flush
			chown system:system ${file}/batch_data
			;;
		"underwater_detect")
			chown system:system ${file}/enable
			chown system:system ${file}/data
			chown system:system ${file}/clear
			chown system:system ${file}/interrupt_kind
			;;
		"piezo_press_sensor")
			chown system:system ${file}/enable_piezo_press_sensor
			chown system:system ${file}/flush
			chown system:system ${file}/prop
			chown system:system ${file}/data
			chown system:system ${file}/poll_delay
			;;
		"piezo_wakeup_sensor")
			chown system:system ${file}/enable_piezo_wakeup_sensor
			chown system:system ${file}/flush
			chown system:system ${file}/prop
			chown system:system ${file}/prop_powkey_th
			chown system:system ${file}/prop_lcdkey_th
			;;
		"ti_msp430")
			chown system:system ${file}/ti_ctrl
			;;
	esac
done

devno=0
for file in /sys/bus/iio/devices/iio:device*; do
	name=`cat ${file}/name`
	case "${name}" in
		"sensor_hub")
			chown system:system ${file}/buffer/enable
			chown system:system ${file}/buffer/length
			chown system:system ${file}/buffer/watermark
			chown system:system ${file}/scan_elements/in_accel_x_en
			chown system:system ${file}/scan_elements/in_accel_y_en
			chown system:system /dev/iio:device${devno}
			chmod 0660 /dev/iio:device${devno}
			;;
	esac
	devno=$(( devno + 1 ))
done
