 (define (problem mars_mission)
  (:domain mars_rover)

  (:objects
    MR_1 - rover
    mars_station loc1 loc2 loc3 - location
    spectrometer camera radar multispectral_camera - instrument
    imu stereoscopic_camera - sensor
  )

(:init
    (at MR_1 mars_station) ;; Rover starts at the mars station
    (instrument_needed spectrometer loc1) ;; Spectrometer needed at loc1
    (instrument_needed camera loc1) ;; Camera needed at loc1
    (instrument_needed spectrometer loc3) ;; Spectrometer needed at loc3
    (instrument_needed camera loc2) ;; Camera needed at loc2
    (instrument_needed radar loc3) ;; Radar needed at loc3
    (= (max_reads loc1 spectrometer) 2) ;; Maximum reads for spectrometer at loc1
    (= (max_reads loc1 camera) 1) ;; Maximum reads for camera at loc1
    (= (max_reads loc2 camera) 1) ;; Maximum reads for camera at loc2
    (= (max_reads loc3 spectrometer) 2) ;; Maximum reads for spectrometer at loc3
    (= (max_reads loc3 radar) 1) ;; Maximum reads for radar at loc3
  )

  ;; Goal state to achieve
  (:goal
    (and
      (transmitted MR_1 spectrometer loc1) ;; Data from spectrometer at loc1 is transmitted
      (transmitted MR_1 camera loc1) ;; Data from camera at loc1 is transmitted
      (transmitted MR_1 spectrometer loc3) ;; Data from spectrometer at loc3 is transmitted
      (transmitted MR_1 camera loc2) ;; Data from camera at loc2 is transmitted
      (transmitted MR_1 radar loc3) ;; Data from radar at loc3 is transmitted
      (at MR_1 mars_station) ;; Rover returns to the mars station
      (not (using_imu MR_1)) ;; IMU is deactivated
      (not (using_stereoscopic_camera MR_1)) ;; Stereoscopic camera is deactivated
      (not (connection_established)) ;; Connection is terminated
    )
  )

  ;; Metric to minimize the total time
  (:metric minimize (total-time))
)