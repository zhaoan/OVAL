<?php
/**
 *  OVAL (Online Video Annotation for Learning) is a video annotation tool
 *  that allows users to make annotations on videos uploaded to the platform.
 *
 *  Copyright (C) 2014  Shane Dawson, University of South Australia, Australia
 *  Copyright (C) 2014  An Zhao, University of South Australia, Australia
 *  Copyright (C) 2014  Dragan Gasevic, University of Edinburgh, United Kingdom
 *  Copyright (C) 2014  Neging Mirriahi, University of New South Wales, Australia
 *  Copyright (C) 2014  Abelardo Pardo, University of Sydney, Australia
 *  Copyright (C) 2014  Alan Kingstone, University of British Columbia, Canada
 *  Copyright (C) 2014  Thomas Dang, , University of British Columbia, Canada
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by 
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

// Auto group creation needs integration in
// the group management page (for users who had logged in before).
//
// in group management, run through the classlist, on selecting a new
// class, check
// if the class list contains users with names, those users automatically get groups
// created for them in that class
//
// that is more elegant than integrating here, because a student may be
// enrolled in multiple classes, and more classes in the future. So they
// will need to log in again for each new course.

// get classes this student belong to

// check group by user_id, and classes
// $myGroups = $user->getMyGroups($ID, )

// create group by user_id and firstname lastname

require_once(dirname(__FILE__) . "/includes/common.inc.php");
require_once(dirname(__FILE__) . "/database/users.php");

define("CREATE_GROUP", "create group");
define("UPDATE_GROUP", "update group");
define("DELETE_GROUP", "delete group");
define("CANCEL", "cancel");


startSession();

// TODO: need to fix this page to work with IE
$usingIE = (strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') !== FALSE);
if ($usingIE) die("<html style='background-color:#eee;'><body><div style='color:red;'>Please use Firefox, Chrome or Safari to access the group management function.<br>All other functions still work correctly in IE.</div></body></html>");

$userName   = $_SESSION['name'];
$userID     = $_SESSION['user_id'];

if (! isAdmin($_SESSION['role'])) die($adminPrivRequiredMsg);


$user = new users();

$classes = $user->getClassesUserBelongsTo($userID);
//print_r($classes);
if (empty($classes)) {
    print "There are no classes associated with your account";
    exit;
}

(isset($_GET['class_id'])) ? $classID = $_GET['class_id'] : $classID = $classes[0]['ID'];
$groups    = $user->getGroupsByClassAndOwner($classID, $userID);
$className = $user->getClassName($classID);
(isset($_GET['group_id'])) ? $groupID = $_GET['group_id'] : $groupID = key($groups);

//print_r($classes);
//print "classID: $classID<br />";
//print_r($groups);    
//print "<br />key(\$groups) " . key($groups) . "<br />";

//print "before formSubmitted<br />";
if (formSubmitted()) {
//print_r($_POST);
    processForm();
}

if (! empty($groups)) $groupMembers = $user->getGroupMembers($groupID);
//print_r($groupMembers);
//print_r($groups);

$classList = $user->getClassList($classID);
/*
foreach ($classList as $student) {
    print_r($student); print "<br />";
}
*/
displayForm();


function processForm() {
    global $user, $userID, $classID, $className, $groupID;    

    $action         = $_POST['submit'];
    $groupName      = $className . " - " . $_POST['group-name'];
    $groupMembers   = $_POST['group-members'];

    $url = "{$_SERVER["SCRIPT_NAME"]}?class_id=$classID";
//print "in processForm()<br />";
    switch ($action) {
        case CREATE_GROUP:
//print "creating<br />";            
            $groupID = $user->createGroup($groupName, $groupMembers, $userID, $classID);
//            $user->getClassInstructorsAndTAs($groupID);
            $groups  = $user->getGroupsByOwner($userID);
            header("location: $url&group_id=$groupID");
            break;               
        case UPDATE_GROUP:
//print "updating<br />";
//print "groupID: $groupID<br />";
//print_r($groupMembers);
            $user->updateGroup($groupID, $groupMembers);
            // if this group is assigned to a video then update videoACL
            $media = new media();
            $media->updateVideoACL($groupID);
            $media->close();
            break;               
        case DELETE_GROUP:
//print "deleting<br />";            
            $user->deleteGroup($groupID);
            header("location: $url");
            exit();
        case CANCEL:
//print "cancelling<br />";            
            header("location: $url&group_id=$groupID");
            exit();
        default:
//print "doing nothing";
            exit();
    }
//print_r($_POST);
}


function displayForm() {
    global $classes, $classList, $className, $groups, $classID, $groupID, $groupMembers, $userName;    
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Manage user groups</title>
<script type="text/javascript" src="kaltura-html5player-widget/jquery-1.4.2.min.js"></script>
<script type="text/javascript">
function jumpBoxClass(list) {
    var url = "manage_groups.php?class_id=" + $('#class').val();
//alert(list.options[list.selectedIndex].value);
//console.log("jumpBoxClass " + url);
    location.href = url;
}

function jumpBoxGroup(list) {
    var url = "manage_groups.php?class_id=<?php=$classID?>" + "&group_id=" + $('#group').val();
//console.log("jumpBoxClass " + url);
    location.href = url;
}

$(document).ready(function() {
    $('#update-conversion-status').click(function() {
        //alert('Handler for .click() called.');
        window.location.reload();
    });

    // fetch groups for given class
    $('#class').change(function() {

    });

    $('#group').change(function() {

    });

    $("#update-groups").submit(function () {
//alert("submit-button.val() " + $("input[type=submit]:focus").val());
        if ("delete group" == $("input[type=submit]:focus").val()) {
            if (confirm("Are you sure you want to delete this group?")) {
                return true;
            } else {
                return false;
            }
        }
    });

    $('#create-group').click(function() {
        showCreateGroup();
        // deselect any class members 
        $('#group-members option').each(function(index) {
            $(this).removeAttr("selected");
        });
          
    });
    $('#update-group').click(function() {
        $('.create-group').css('display', 'none');
        $('#create-group').css('display', 'inline');
        $('.update-group').css('display', 'inline');
        $('#update-group').css('display', 'none');
        $('title').text("Update User Groups");
        $('legend').text("Update User Groups");
    });
    function showCreateGroup(groupsExist) {
        $('.create-group').css('display', 'inline');
        $('#create-group').css('display', 'none');
        $('.update-group').css('display', 'none');
//        if (groupsExist) $('#update-group').css('display', 'inline');
        $('title').text("Create User Group");
        $('legend').text("Create User Group");
    }

});

</script>
<link rel="stylesheet" type="text/css" href="style.css" />
<link rel="stylesheet" type="text/css" href="admin-page.css" />
</head>
<body>
<div id="wrapper">
<?php 
    printAdminBar(false,$userName);     
    if (empty($groups)) {
        $createStyle    = "display:inline";
        $updateStyle    = "display:none";
        $legend         = "Create User Group";
        $msg            = "<p style=\"font-weight:bold;\">There are no groups associated with this class.<br />Please create a group.</p>";
    } else {
        $createStyle    = "display:none";
        $updateStyle    = "display:inline";
        $legend         = "Manage User Groups";
    }
?>
<div style="clear:both"></div>
<?php echo $msg?>
<div class="form">
<h3><?php echo $legend?></h3>
<form id="update-groups" name="update-groups" method="post" action="">
    <label>select class
    <select name="class" id="class" onchange="jumpBoxClass()">
<?php
//print "classID: $classID"; 
    foreach ($classes as $class) {
//print_r($class);        
        $ID     = $class['ID'];
        $name   = $class['name']; 
        ($classID == $ID) ? $selected="selected=\"selected\"" : $selected="";
        print "\t<option value=\"$ID\" $selected>$name</option>\n";
    }                
?>
    </select>
    </label>
    <strong style="padding-left:10px;"><?php echo count($classList)?></strong> students have accounts
    <br />
    <div class="create-group" style="<?php echo $createStyle?>">
        <label style="width:180px;">new group name<br />
            <span style="float:left;background-color:#D9E2E9;padding-left:2px;"><?php echo "$className - "?>&nbsp;<input type="text" name="group-name" size="20" id="group-name" maxlength="45" style="float:right" /></span>
        </label>
    </div>
    <div class="update-group" style="<?php echo $updateStyle?>">
        <span id="create-group" class="create-group" style="float:right;padding-right:300px;color:#black;text-decoration:underline;cursor:pointer;">create new group</span>
        <label>
        edit group
        <select name="group" id="group" onchange="jumpBoxGroup()">
<?php    
    foreach ($groups as $ID=>$name) {
//print "selected$selected<br />";        
        ($groupID == $ID) ? $selected="selected=\"selected\"" : $selected="";
        print "\t<option value=\"$ID\" $selected>$name</option>\n";
    }
?>
        </select>
        </label>
    </div>        
    <br style="clear:left" />
    <label>group members
    <div style="position:relative;top:150px;left:240px;">(instructors and TAs are automatically included in groups)</div>
    <select name="group-members[]" size="20" multiple="multiple" id="group-members">
<?php
    foreach ($classList as $member) {
//print_r($member);
        // if the userName is not initialized
        (" " == ($member["name"])) ? $userName="--- NAME UNINITIALIZED" : $userName=$member["name"];
        $userID     = $member["ID"];

        (in_array($userID, $groupMembers)) ? $selected="selected=\"selected\"" : $selected="";
        if ($member["is_instructor"]) { 
            $style="style=\"font-weight:bold;\"";
            $userName .= " (Instructor)";
        } elseif ($member["is_ta"]) {
            $style="style=\"font-weight:bold;\"";
            $userName .= " (TA)";
        } else {
            // $member["is_student"]
            $style="";
        }
?>
                <option value="<?php echo $userID?>" <?php echo $selected . $style ?> ><?php echo "$userName"?></option>
<?php } ?>
    </select>
    </label>
    <label>
    <br />
    <div class="create-group" style="<?php echo $createStyle?>">
        <input type="submit" name="submit" id="create-group" value="<?php echo CREATE_GROUP?>" />
        <input type="submit" name="submit" id="cancel" value="<?php echo CANCEL?>" />
    </div>
    <div class="update-group" style="<?php echo $updateStyle?>">
        <input type="submit" name="submit" id="update-group" value="<?php echo UPDATE_GROUP?>" />
        <input type="submit" name="submit" id="delete-group" value="<?php echo DELETE_GROUP?>" />
    </div>
    <br />
    <br />
    <strong>Note:</strong> to make a non-contiguous selection hold the CTRL key while making selection
    </label>
</form>
</div>
</div> <!-- wrapper for page centering -->
<!-- <div id="univbranding"><img src="icons/LearnngTchngUnt_12_01.png"></img></div>  -->

<!-- <div id="mydiv">
        <p><b>OVAL has been collaboratively developed with support from University of British Columbia, University of South Australia, University of Sydney and University of New South Wales.</b></p> <p><b>Support for the software and research has been provided by the Australian Government Office for Learning and Teaching.</b></p>
</div>  -->

</body>
</html>
<?php 
} 

?>
