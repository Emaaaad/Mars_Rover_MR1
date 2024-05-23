(define (domain mars_rover)
  (:requirements :strips :typing :negative-preconditions :conditional-effects)

  (:types
    location rover instrument sensor
  )

  (:predicates
    (at ?r - rover ?l - location)
    (stable ?r - rover)
    (manipulator_extended ?r - rover)
    (end_effector_positioned ?r - rover)
    (deployed ?r - rover ?i - instrument)
    (collected ?r - rover ?i - instrument ?l - location)
    (processed ?r - rover ?i - instrument ?l - location)
    (transmitted ?r - rover ?i - instrument ?l - location)
    (instrument_needed ?i - instrument ?l - location)
    (visited ?r - rover ?l - location)
    (activated ?r - rover ?i - instrument)
    (using_imu ?r - rover)
    (using_stereoscopic_camera ?r - rover)
    (mission_complete ?r - rover)
    (connection_established)
  )

  ;; Functions defining numeric values
  (:functions
    (number_reads ?r - rover ?i - instrument ?l - location)
    (max_reads ?l - location ?i - instrument)
  )


  ;; Action to navigate the rover from one location to another
  (:action navigate
    :parameters 
    (?r - rover ?from - location ?to - location)
    
    :precondition 
    (and (at ?r ?from) (using_imu ?r) (using_stereoscopic_camera ?r) (connection_established) (not (= ?from ?to)))
    
    :effect 
    (and (at ?r ?to) (not (at ?r ?from)) (visited ?r ?to))
  )

  ;; Action to activate the IMU
  (:action activate_imu
    :parameters 
    (?r - rover)
    
    :precondition 
    (and (not (using_imu ?r)) (connection_established))
    
    :effect 
    (using_imu ?r)
  )

  ;; Action to deactivate the IMU
  (:action deactivate_imu
    :parameters 
    (?r - rover)
    
    :precondition 
    (using_imu ?r)
    
    :effect 
    (not (using_imu ?r))
  )

  ;; Action to activate the stereoscopic camera
  (:action activate_stereoscopic_camera
    :parameters 
    (?r - rover)
    
    :precondition 
    (and (not (using_stereoscopic_camera ?r)) (connection_established))
    
    :effect 
    (using_stereoscopic_camera ?r)
  )

  ;; Action to deactivate the stereoscopic camera
  (:action deactivate_stereoscopic_camera
    :parameters 
    (?r - rover)
    
    :precondition 
    (using_stereoscopic_camera ?r)
    
    :effect 
    (not (using_stereoscopic_camera ?r))
  )

  ;; Action to stabilize the rover
  (:action stabilize
    :parameters 
    (?r - rover ?l - location)
    
    :precondition 
    (and (at ?r ?l) (not (stable ?r)) (not (= ?l mars_station)))
    
    :effect 
    (stable ?r)
  )

  ;; Action to extend the rover's manipulator
  (:action extend_manipulator
    :parameters 
    (?r - rover)
    
    :precondition 
    (and (stable ?r) (not (manipulator_extended ?r)) (connection_established))
    
    :effect 
    (manipulator_extended ?r)
  )

  ;; Action to position the end effector
  (:action position_end_effector
    :parameters 
    (?r - rover)
    
    :precondition 
    (and (manipulator_extended ?r) (not (end_effector_positioned ?r)) (connection_established))
   
    :effect 
    (end_effector_positioned ?r)
  )

  ;; Action to deploy an instrument
  (:action deploy_instrument
    :parameters 
    (?r - rover ?i - instrument)
    
    :precondition 
    (and (stable ?r) (end_effector_positioned ?r) (not (deployed ?r ?i)) (connection_established))
    
    :effect 
    (deployed ?r ?i)
  )

  ;; Action to activate an instrument
  (:action activate_instrument
    :parameters 
    (?r - rover ?i - instrument)
    
    :precondition 
    (and (deployed ?r ?i) (not (activated ?r ?i)) (connection_established))
   
    :effect 
    (activated ?r ?i)
  )

  ;; Action to collect data with an instrument
  (:action collect_data
    :parameters 
    (?r - rover ?i - instrument ?l - location)
    
    :precondition 
    (and (activated ?r ?i) (at ?r ?l) (instrument_needed ?i ?l) (< (number_reads ?r ?i ?l) (max_reads ?l ?i)) (connection_established))
    
    :effect 
    (and (collected ?r ?i ?l) (increase (number_reads ?r ?i ?l) 1))
  )
  
  
  ;; Action to process collected data
  (:action process_data
    :parameters 
    (?r - rover ?i - instrument ?l - location)
   
    :precondition 
    (and (collected ?r ?i ?l) (connection_established))
   
    :effect 
    (processed ?r ?i ?l)
  )

  ;; Action to transmit processed data
  (:action transmit_data
    :parameters 
    (?r - rover ?i - instrument ?l - location)
    
    :precondition 
    (and (processed ?r ?i ?l) (connection_established))
   
    :effect 
    (transmitted ?r ?i ?l)
  )

  ;; Action to retract the manipulator
  (:action retract_manipulator
    :parameters 
    (?r - rover)
    
    :precondition 
    (and (manipulator_extended ?r) (connection_established))
   
    :effect 
    (not (manipulator_extended ?r))
  )

  ;; Action to retract an instrument
  (:action retract_instrument
    :parameters (?r - rover ?i - instrument)
    
    :precondition 
    (and (deployed ?r ?i) (connection_established))
   
    :effect 
    (not (deployed ?r ?i))
  )
  
  
  ;; Action to collect data with multiple instruments
  (:action collect_data_with_instruments
    :parameters 
    (?r - rover ?l - location ?i1 - instrument ?i2 - instrument)
    
    :precondition 
    (and (at ?r ?l) (instrument_needed ?i1 ?l) (instrument_needed ?i2 ?l) (connection_established))
    
    :effect (and 
              (when (deployed ?r ?i1) (collected ?r ?i1 ?l))
              (when (deployed ?r ?i2) (collected ?r ?i2 ?l))
            )
  )


  ;; Action to mark the mission as complete
  (:action mark_mission_complete
    :parameters (?r - rover)
    
    :precondition (and 
                    (transmitted ?r spectrometer loc1)
                    (transmitted ?r camera loc1)
                    (transmitted ?r spectrometer loc3)
                    (transmitted ?r camera loc2)
                    (transmitted ?r radar loc3)
                    (connection_established))
    
    :effect (mission_complete ?r)
  )
  
  
    ;; Action to return to the mars station
  (:action return_to_mars_station
    :parameters 
    (?r - rover ?from - location)
   
    :precondition 
    (and (at ?r ?from) (mission_complete ?r) (connection_established))
    
    :effect 
    (and (at ?r mars_station) (not (at ?r ?from)))
  )


  ;; Action to establish connection
  (:action make_connection
    :parameters 
    (?r - rover)
   
    :precondition 
    (at ?r mars_station)
    
    :effect 
    (connection_established)
  )

  ;; Action to terminate connection
  (:action terminate_connection
    :parameters 
    (?r - rover)
    
    :precondition 
    (and (at ?r mars_station) (mission_complete ?r) (connection_established))
    
    :effect 
    (not (connection_established))
  )
)
