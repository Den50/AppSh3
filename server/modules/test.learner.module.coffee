addTest = (schema, data)->
	_data = new schema
	DATA = Object.assign _data, data
	DATA.save()
	console.log "save -> ok"

getTests = (schema)->
	schema.find().then (data)->
		data

updateTest = (schema, id, news)->
	schema.findByIdAndUpdate id, { $set: news}, { new: true }, (err, doc)->
  if err then throw err
  console.log doc

	# schema.findById id, (err, doc)->
	# 	if err then throw err

	# 	doc[Object.keys(news)[0]] = new[Object.keys(news)[0]]
	# 	doc.save (err, updatedDoc)=>
	# 		if err then throw err
	# 		console.log updatedDoc



module.exports = {addTest: addTest, getTests: getTests, updateTest: updateTest}