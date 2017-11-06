{DeviceOrientationManager} = require "DeviceOrientationManager"
orientationManager = new DeviceOrientationManager
Screen.backgroundColor = "28affa"

{ mapboxgl } = require "npm"

#mapSetup
mapLayer = new Layer
	height: Screen.height
	width: Screen.width
	parent:nullLayer

mapLayer.html = "<div id='map'></div>"
mapLayer.ignoreEvents = false
mapElement = mapLayer.querySelector("#map")
mapElement.style.height = Screen.height + 'px'

# Set your Mapbox access token here
mapboxgl.accessToken = 'pk.eyJ1Ijoia2V5dXJqYWluMjEiLCJhIjoiY2lpamk4eWl5MDEycXVka242bTB5aXk5MCJ9.YwZqFTtsJKymb8vAENy3wA'


map = new mapboxgl.Map
	container: mapElement
	zoom: 13
	center: [12.608,55.680]
	style: 'mapbox://styles/keyurjain21/cj9n6g9zf36wv2slnar5m3vxd'
	
coordinates = {latitude : 0, longitude : 0}

success = (p) ->
	coordinates.latitude = p.coords.latitude
	coordinates.longitude = p.coords.longitude
# 	print coordinates
	box.html="OK"
	return

error = (msg) ->
#   print "error"
  box.html="X"

  return


#Get the device location + Fly to  
box.onTap (event, layer) ->
	navigator.geolocation.getCurrentPosition(success, error)
	Utils.delay 1, ->
		map.flyTo({center: [coordinates.longitude, coordinates.latitude]});


# 	print distance(sourceCoordinates, targetCoordinates[0])
# 	print "Osterbro:" + heading(sourceCoordinates, targetCoordinates[0])
# 	print "Papiroen:" + heading(sourceCoordinates, targetCoordinates[1])
# 	print "Kongens:" + heading(sourceCoordinates, targetCoordinates[2])
# 	print "Tivoli:" + heading(sourceCoordinates, targetCoordinates[3])
# 	print "Zoo:" + heading(sourceCoordinates, targetCoordinates[4])
# 	print "Norreport:" + heading(sourceCoordinates, targetCoordinates[5])
	
#distance
distance = (originCoordinates, destinationCoordinates) ->
	degToRad = Math.PI / 180
	lat1 = originCoordinates.latitude
	lon1 = originCoordinates.longitude
	
	lat2 = destinationCoordinates.latitude
	lon2 = destinationCoordinates.longitude
	
	R = 6371000 # metres
	
	φ1 = lat1 * degToRad
	φ2 = lat2 * degToRad
	Δφ = (lat2-lat1) * degToRad
	Δλ = (lon2-lon1) * degToRad
	a = Math.sin(Δφ/2) * Math.sin(Δφ/2) + Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ/2) * Math.sin(Δλ/2)
	c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
	d = R * c
	return d

# heading
heading = (originCoordinates, destinationCoordinates) ->
	degToRad = Math.PI / 180

	lat1 = originCoordinates.latitude * degToRad
	lon1 = originCoordinates.longitude * degToRad
	lat2 = destinationCoordinates.latitude * degToRad
	lon2 = destinationCoordinates.longitude * degToRad

	angle = Math.atan2(Math.sin(lon2 - lon1) * Math.cos(lat2), Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1))
	headingAngle = angle * 180 / Math.PI
	headingAngle += 360 if headingAngle < 0
	return headingAngle

# Section 2

disk.opacity= 0
disk_0.opacity=0
disk_1.opacity=0
disk_2.opacity=0

errorText = new TextLayer
	parent:errorBox
	color: "black"
	textAlign: "center"
	fontSize: 30
	opacity:0

rotationNormalizer = Utils.rotationNormalizer()

orientationManager.onOrientationChange (data) ->
	compassHeading = data.compassHeading
	compassHeading *= -1 if data.elevation < 0
	NorthAngle = rotationNormalizer(compassHeading)

	sourceCoordinates = coordinates
	
	#List of coordinates
	targetCoordinates = [
		{latitude : 55.705, longitude : 12.578},
		{latitude : 55.680, longitude : 12.598},
		{latitude : 55.679, longitude : 12.585},
		{latitude : 55.674, longitude : 12.568},
		{latitude : 55.672, longitude : 12.571},
		{latitude : 55.683, longitude : 12.572}
	]

	angle_0 = NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[0])))
	angle_1 = NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[1])))
	angle_2 = NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[2])))
	angle_3 = NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[3])))
	angle_4 = NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[4])))
	
	r=Math.floor(data.compassHeading)
	
	if r<=180
		b = -r
	else b=360-r
	
	errorText.html = b

	
	disk.animate
		properties: rotation: NorthAngle
		time: 0.1
	
	disk_0.animate
		properties: rotation: angle_0
		time: 0.1

	disk.animate
		properties: rotation: NorthAngle
		time: 0.1
	
	disk_0.animate
		properties: rotation: angle_0
		time: 0.1

confirmButton.onTap (event, layer) ->
	disk.opacity = 1
	errorText.opacity = 1


disk_0.states=
	stateA:
		opacity:1
	stateB:
		opacity:0

disk_1.states=
	stateA:
		opacity:1
	stateB:
		opacity:0

disk_2.states=
	stateA:
		opacity:1
	stateB:
		opacity:0



button_0.onClick (event, layer) ->
	disk_0.stateCycle()

button_1.onClick (event, layer) ->
	disk_1.stateCycle()

button_2.onClick (event, layer) ->
	disk_2.stateCycle()