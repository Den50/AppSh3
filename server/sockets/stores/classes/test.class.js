import dispatcher from "../dispatcher";
// Подключаем контент из Chat
export default (Chat) => class extends Chat {
	constructor(){
		super("Hello")
		this.data_users = [];
	}
	changeUsrData(data){
		console.log(data.type)
		switch(data.type){
			case "lname":
				this.updateClient(data.id, {lname: data.payload.value});break;
			case "fname": 
				this.updateClient(data.id, {fname: data.payload.value});break;
			case "variant": 
				this.updateClient(data.id, {variant: data.payload.value});break;
			case "start": 
				this.updateClient(data.id, {testing: data.payload.state});break;

			default: {
				console.log(":/, Не сработал свитч")
			}
		}
	}

	updateAnswerUser(id, data){
		let self = this;
		if(this.data_users.length > 0) {
			let updated = false;
			this.data_users.map((i, j) => {
				if(i.id == id){
					let no = false;
					i.data.map((k, l) => {
						if(k.no == data.no){
							self.data_users[j].data[l].value = data.value;
							no = true;
						}
					})

					if(!no){
						self.data_users[j].data.push(data)
					}
					updated = true;
				}
			})
			if(!updated){
				this.data_users.push({
					id: id,
					data: [data]
				})
			}
		}
		else{
			this.data_users.push({
				id: id,
				data: [data]
			})
		}
		// this.data_users.map((i) => {
		// 	console.log(i.data)
		// })
		dispatcher.dispatch({
			type: "UPDATE_ANSWER_USER",
			payload: this.data_users
		})
	}
};