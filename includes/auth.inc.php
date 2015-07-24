<?php

include_once(dirname(__FILE__) . "/global_deploy_config.php");
include_once(dirname(__FILE__) . "/../database/users.php");
include_once(dirname(__FILE__) . "/common.inc.php");


function isUserAuthorized($userID)
{
    return false;
    $hashUserID = hash("sha256", $userID);

    $user = new UsersCWL();
     check User table to see if user exists
    $user = $user->getUser($hashUserID);

    if (is_null($user)) {
        return false;
    } else {
        return true;
    }    
    
}


/*
 * for authentication purposes the seed needs to be computable from the input $ID 
 * (so it's not a salt in the traditional sense) however it accomplishes a similar purpose 
 * by generating a unique string for each $ID
 *
 */
function generateSalt($ID)
{
    // this string must remain constant otherwise the authentication will not work
    /*
     * CUSTOMIZE_THIS: Reimplement this function for your school.
     */


    return $salt;
}

/*
 * generate a hashed ID, use strong encryption for storing student numbers and employee IDs
 *
 */
function hashUserID($ID)
{
    $salt1  = generateSalt($ID);
    // reverse the $ID and generate another salt
    $salt2  = generateSalt(strrev((string) $ID));
    $salted = $salt1 . $ID . $salt2;

    $hashUserID = hash("sha256", $salted);
    

    return $hashUserID;
}


function startSession() 
{
    global $_SERVER, $notAuthorizedURL, $DEPLOYMENT_NAME;

    // $_SERVER variables courtesy of Shibboleth
    $firstName      = $_SERVER['givenName'];
    $lastName       = $_SERVER['sn'];
    
    session_start();

	$userID = getCurrentClasUserId();    
	$user   = new Users();
	
    if (! isset($_SESSION['authenticated'])) {
        
         if still no user then account does not exist
         not authorized

        if (is_null($userID)) {
			notAuthorized();
        } else {
            $currentClasUser = $user->getUserInfo(array($userID));
            $currentClasUser = $currentClasUser[0];
            
            $currentFirstName = null;
            $currentLastName = null;
            if (!is_null($currentClasUser)) {
	            $currentFirstName = $currentClasUser['first_name'];
	            $currentLastName = $currentClasUser['last_name'];
            } 
            
            if (!is_null($currentFirstName) && $currentFirstName != "" &&
            		trim(strtoupper($currentFirstName)) != "NULL") {
            	$firstName = $currentFirstName;
            }
            	
            if (!is_null($currentLastName) && $currentLastName != "" && 
            		trim(strtoupper($currentLastName)) != "NULL") {
            	$lastName = $currentLastName;
            }
            
            $nameNotAvailable = false;
            if (
            	($firstName == null && $lastName == null) ||
            	($firstName == "" && $lastName == "") ||
            	($firstName == "NULL" && $lastName == "NULL")
            	) {
            	$firstName = "Name";
            	$lastName = "Not Available";
            	$nameNotAvailable = true;
            }

            //An ZHAO added for USyd pilot.
                
                $firstName = $_SERVER['givenName'];
                $lastName  = $_SERVER['sn'];

        	$userName = $firstName . " " . $lastName;
            
            $isAdmin  = true;

            $currentClasUser = $user->getUserInfo(array($userID));
			$role = $currentClasUser[0]['role'];

            $_SESSION['name']           = $userName;
            $_SESSION['role']           = $role;
            $_SESSION['user_id']        = $userID;
            $_SESSION['authenticated']  = 1;

            // write user name to database
            if (!$nameNotAvailable) {
            	$user->setName($firstName, $lastName, $userID);
            }
            
            // log session start
            $user->recordLogin($userID);
                 
            
        }

    } else {
		print "isset(\$_SESSION['authenticated'])";
    }
    $user->close();
}

function endSession()
{
    global $_SESSION;

    unset($_SESSION['authenticated']);
    session_destroy();
}

// Post condition: returns the user ID within OVAL, based on the unique ID from Shib
function getCurrentClasUserId() {
	global $_SERVER;
	
	$employeeNum    = $_SERVER['employeeNumber'];
	$studentNum     = $_SERVER['studentNumber'];
	$eduPersonAffiliation = $_SERVER['eduPersonAffiliation'];
        $givenName = $_SERVER['givenName'];
        $sn = $_SERVER['sn'];
        $mail = $_SERVER['mail'];
	

	$user   = new Users();
	$userID = $user->getByID($studentNum);
	
	if (is_null($userID)) {
		// try again using employee ID
		$userID = $user->getByID($employeeNum);
	}
        
        
        if (is_null($userID)) {
             
           $userID = $user->getByMail($mail);

        }

	
	// ok if Affiliation type is "affiliate" (guest) then lookup using the user ID
	// this way the pool of user ID is limited to only the guest IDs, so clashes 
	// is unlikely to happen. The only clash that can happen is through time, if
	// a guest ID is cancelled, and then someone create the same again.
	
	// TODO: Is there anyway to authenticate using PUID? The problem is that this is not available
	// before first login so the user cannot give it to you to create an account with
	// 
	// So unless there is a way to look up PUID at account creation from the student number 
	// then hash the PUID, we won't be able to do PUID login.
	//
	// for now let's just go with guest ID.
	
	if (is_null($userID)) {
		
		
		// Allow students and staffs to authenticate with
		// their cwl ID too even if they don't provide a student or employee number
		// the right implementation should be to allow either at first, but collect the hashed 
		// student / employee num after first login, so that you don't end if with two accounts
		// for a student or staff, one with the CWL ID and one with the unique ID.
		
		 if ($eduPersonAffiliation == "affiliate") {
			
                        $userID = $user->getByGN($givenName,$sn);
                      
		}
	}
	

	return $userID;
}

// Post condition: return the hash of the unique ID derived from the CurrentClasUserId()
function getCurrentHashedUId() {
	$userID = getCurrentClasUserId();
	
	$user   = new Users();
	$userInfo = $user->getUserInfo(array($userID));
	
	return $userInfo[0]['hash_user_id'];
}

function notAuthorized() {
	global $notAuthorizedURL;
	
	session_destroy();
	header("Location: $notAuthorizedURL");
	exit;
}

function isAdmin($role)
{
    return (STUDENT != $role);
}

?>
