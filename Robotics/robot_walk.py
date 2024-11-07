#!/usr/bin/env python3
import rospy
from turtlesim.msg import Color
from turtlesim.srv import SetPen
from geometry_msgs.msg import Twist
import random
import math

# Globals for rate control
droprate = 30  
droppacket = 0  

# Callback for color sensor updates
def colour_update(msg):
    global droprate, droppacket

    # Stop if on green square
    if (msg.r == 0) and (msg.g == 255) and (msg.b == 0):
        dead_stop = Twist()  # No movement
        twist_pub.publish(dead_stop)
        rospy.loginfo("Success! The robot reached the green square and stopped.")
        return

    # Reverse slightly and add random turn if on red boundary
    if (msg.r == 255) and (msg.g == 0) and (msg.b == 0):
        droppacket = 1
        backup = Twist()
        backup.linear.x = -3  # Reverse
        backup.angular.z = 3.14 * random.uniform(-0.5, 0.5)  # Small random turn
        twist_pub.publish(backup)
        return

    # Skip publishing if not at droprate
    droppacket = (droppacket + 1) % droprate
    if droppacket != 0:
        return

    # Random move: 50/50 forward or rotate
    next_move = Twist()
    if random.randint(0, 1) == 0: 
        next_move.linear.x = 3  # Forward
    else:
        next_move.angular.z = 3.14 * random.uniform(-1, 1)  # Random rotation
    twist_pub.publish(next_move)

# ROS Node setup
if __name__ == '__main__':
    rospy.init_node('random_walker', anonymous=True)

    # Color subscriber
    colour_sub = rospy.Subscriber("turtle1/color_sensor", Color, colour_update, queue_size=1)

    # Movement publisher
    twist_pub = rospy.Publisher('turtle1/cmd_vel', Twist, queue_size=1)

    # Turn off pen to avoid path interference
    try:
        rospy.wait_for_service('turtle1/set_pen')
        set_pen = rospy.ServiceProxy('turtle1/set_pen', SetPen)
        set_pen(0, 0, 0, 0, 1)  # Disable pen
    except rospy.ServiceException as e:
        rospy.logerr(f"Service call failed: {e}")

    # Spin to keep node running
    try:
        rospy.spin()
    except KeyboardInterrupt:
        rospy.loginfo("Program interrupted by keyboard")
