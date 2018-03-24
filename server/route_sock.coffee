crypto = require('crypto')
learner_chat = (socket, store)->
	id = socket.id
	console.log "connected user, id: #{id}"
	ip = socket.handshake.address
	store.addNewClient 
		id: id
		ip: socket.handshake.address
		type: "learner"
		privileges: 3
	socket.emit 'connected', id: id, ip: ip
	### Main methods learner ###
	socket.on "setNameLearner", (data)->
		nameOnline = no
		for i in store.getClients()
			if i.name == data.name
				nameOnline = on
				break
		if !nameOnline
			store.updateClient data.id, {name: data.name}
		else
			console.log "name is holded"
		console.log store.getClients()

	socket.on "newMassageToChat", (data)->
		console.log "id: #{data.id} | text: #{data.text}"

		socket.broadcast.emit "newMassageToChatUsers", {id: data.id, name: data.name, text: data.text}
		socket.emit "newMassageToChatUsers", {id: data.id, name: data.name, text: data.text}
		
		# appendToFile "./db.log", "#{data.id}: #{data.text}\n"

		###Closed Bar Browser method###
	socket.on "closed", (data)->
		console.log "disconnect user, id: #{data.id}"
		store.deleteClient data.id

encryptHash = (key, data)->
	cipher = crypto.createCipher('aes-256-cbc', key)
	crypted = cipher.update(data, 'utf-8', 'hex')
	crypted += cipher.final('hex')
	return crypted


decryptHash = (key, data)->
	decipher = crypto.createDecipher('aes-256-cbc', key)
	decrypted = decipher.update(data, 'hex', 'utf-8')
	decrypted += decipher.final('utf-8')
	return decrypted

admin = (socket, store)->
	###Admin funcs and methods...###
	adminOnline = store.getAdminOnline()
	ip = socket.handshake.address
	console.log adminOnline

	DATA = 
		login: "root"
		password: "adminsh3"
	hash = encryptHash DATA.login, DATA.password
	# socket.emit "StartAdmin", {ip: ip, hash: encryptHash DATA.login, DATA.password}
	###Если админ не в сети###
	if !adminOnline
		socket.emit "StartAdmin", {online: no}
		socket.on "adminLogin", (data)->
			_data = data
			# data -> login, password
			_data.ip = socket.handshake.address
			if hash == data.hash
				store.setAdmin
					ip: _data.ip
					type: "admin"
					login: true
					privileges: 10
					hash: _data.hash

				socket.emit "adminLoginSuccess", type: on
				console.log "Login! #{_data.ip} -> admin"
				console.log store.getAdmin()

				# ee.emit "redirectToAdmin", type: true
				# app.redirect "/admin", "/admin"
			else
				console.log "wrong!Login or password incorrected!"
				socket.emit "err", {num: 1}
		###Если админ в сети###			
	else
		console.log "admin online"
		if ip == store.getAdmin().ip
			socket.emit "YOUADMIN", {type: true}
		else
			socket.emit "err", {num: 2}

module.exports = {learner_chat: learner_chat, admin: admin}