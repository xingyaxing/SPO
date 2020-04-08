#!/usr/bin/env python
import rospy
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist
import math
#словарь
sides_ = {	
	'right': 0,
	'front': 0,
	'left': 0,
}
# Деление на датчики справа слева и спереди
def laser(msg):
	global sides_ 
	sides_ = { 
		'right': min(min(msg.ranges[0:30]),4), 
		'front': min(min(msg.ranges[31:70]),4),
		'left': min(min(msg.ranges[71:99]),4),
	}

# Создаем и подписываемся на нужные ROS-ноды
rospy.init_node('reading_laser') 
sub = rospy.Subscriber('/base_scan', LaserScan, laser)
pub = rospy.Publisher('/cmd_vel', Twist, queue_size=1)

while not rospy.is_shutdown(): 
	msg = Twist()
	if sides_['front'] > 1.2: 					# Если можно ехать вперед
		err = -0.4 + sides_['left'] 			# Пропорциональный регулятор вдоль левой стены
		msg.angular.z = err * 0.5
		msg.linear.x = 1
	elif sides_['right'] > sides_['left']: 		# Если впереди стена и справа больше места, вращаемся вправо
		msg.linear.x = 0
		msg.angular.z = -0.7
	elif sides_['right'] < sides_['left']: 		# Иначе влево
		msg.linear.x = 0
		msg.angular.z = 0.7
	else:				
		msg.linear.x = 0.2						# Если показатели равны, то есть с обеих сторон нет стенок
		msg.angular.z = -0.4
	
	pub.publish(msg)

# Использован пропорциональный регулятор и видоизмененный алгоритм обхода лабиринта по левой руке
# 1.2 и 0.4 - расстояния, подобранные через тесты
# 0.5 - Коэффициент, полученный так же вручную
