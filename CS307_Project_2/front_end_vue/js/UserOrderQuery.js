var app = new Vue({
    el:"#app",
    data:{
        address:"http://192.168.43.13:2727/",
        message:"heima",
        arrbuy:[],
        arrRes:[],
        inputValue:"",
        ticket_id:"",
    },
    methods:{
        getMes:function (){
            this.arrbuy.push(this.inputValue);
            this.inputValue = "";
            var that = this;
            axios.get(this.address+"queryTicketsById?"+"id_card_num="+this.arrbuy[0])
                .then(function (response){
                        console.log(response);
                        that.arrRes = response.data;
                    },
                )
                .catch(function (err){})

        },

        add:function () {
            this.arrbuy.push(this.inputValue);
            this.inputValue = "";
        },
        clear:function (){
            this.arrbuy = [];
            this.inputValue = "";
        },
        addstation:function (station){
            this.arrbuy.push(station);
        }
    },
})