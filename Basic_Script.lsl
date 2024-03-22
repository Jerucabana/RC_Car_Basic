// ██████╗   ██████╗ ██╗     ██████╗ ███████╗███╗   ██╗    ██╗  ██╗███╗   ██╗██╗ ██████╗ ██╗  ██╗████████╗
// ██╔════╝ ██╔═══██╗██║     ██╔══██╗██╔════╝████╗  ██║    ██║ ██╔╝████╗  ██║██║██╔════╝ ██║  ██║╚══██╔══╝
// ██║  ███╗██║   ██║██║     ██║  ██║█████╗  ██╔██╗ ██║    █████╔╝ ██╔██╗ ██║██║██║  ███╗███████║   ██║   
// ██║   ██║██║   ██║██║     ██║  ██║██╔══╝  ██║╚██╗██║    ██╔═██╗ ██║╚██╗██║██║██║   ██║██╔══██║   ██║   
// ╚██████╔╝╚██████╔╝███████╗██████╔╝███████╗██║ ╚████║    ██║  ██╗██║ ╚████║██║╚██████╔╝██║  ██║   ██║   
//  ╚═════╝  ╚═════╝ ╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═══╝    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   
                                                                                                       
// ███████╗ ██████╗ ███████╗████████╗██╗    ██╗ █████╗ ██████╗ ███████╗                                   
// ██╔════╝██╔═══██╗██╔════╝╚══██╔══╝██║    ██║██╔══██╗██╔══██╗██╔════╝                                   
// ███████╗██║   ██║█████╗     ██║   ██║ █╗ ██║███████║██████╔╝█████╗                                     
// ╚════██║██║   ██║██╔══╝     ██║   ██║███╗██║██╔══██║██╔══██╗██╔══╝                                     
// ███████║╚██████╔╝██║        ██║   ╚███╔███╔╝██║  ██║██║  ██║███████╗                                   
// ╚══════╝ ╚═════╝ ╚═╝        ╚═╝    ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝      
//
// Created By Pandora Breyer
//
// Instructions:
// Turning on and off are made on the open chat. there are two commands.
// start : Starts the car. The system will ask for you permissioins to take control. Chose Yes.
//         Then you will be able to remotely control the car with the direction keys and your char will stand.
// stop : Turns off the car and your arrow controls are released and you can move your character again.
//
// Have fun. Call me to talk inworld in OSGrid.
//
integer stat = FALSE;
string message1 = "Off";
string message2 = "On";
vector COLOR_GREEN = <0.0, 1.0, 0.0>;
key owner = llGetOwner();
integer controls_taken = FALSE;

setVehicle()
{
    //car
    llSetVehicleType(VEHICLE_TYPE_CAR);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.2);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.1);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.1);
    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <10.0, 2.0, 1000.0>);
    llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <0.1, 0.1, 0.1>);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.50);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 0.50);
 
}

release_controls()
{
    if (controls_taken) {
        controls_taken = FALSE;
        llReleaseControls();
    }
}

default
{
   on_rez(integer start_param)
   {
       integer stat = FALSE;
       string message1 = "Off";
       string message2 = "On";
       vector COLOR_GREEN = <0.0, 1.0, 0.0>;
       llSetText(message1, COLOR_GREEN, 1.0);
       llOwnerSay(llKey2Name(llGetOwner()));
       llListen(0,"",llGetOwner(),"");
    }
    listen(integer channel, string name, key id, string m)
    {
        if (m=="start")
            {
                stat=TRUE;
                llSetText(message2, COLOR_GREEN, 1.0);
                llInstantMessage(owner, "I'm now turned on");
                setVehicle();
                llSetStatus(STATUS_PHYSICS, TRUE);
                llRequestPermissions(owner, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
            }else if (m=="stop"){
                stat=FALSE;
                llSetText(message1, COLOR_GREEN, 1.0);
                llInstantMessage(owner, "I'm now turned off");
                llSetStatus(STATUS_PHYSICS, FALSE);
                llReleaseControls();
            }        
        
    }
    
    control(key name, integer level, integer edge)
    {
        vector angular_motor;
        if (level & CONTROL_FWD) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <10,0,0>);
        }
        if (level & CONTROL_BACK) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-10,0,0>);
        }        
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)){
            angular_motor.z -= 100;
        }
        if (level & CONTROL_LEFT || level & CONTROL_ROT_LEFT) {
           angular_motor.z += 100; 
        }
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
    }
    
    run_time_permissions(integer perms)
    {
        if (perms & PERMISSION_TAKE_CONTROLS) {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_UP | CONTROL_DOWN, TRUE, FALSE);
        } else {
            release_controls();
        }
    }
}

 