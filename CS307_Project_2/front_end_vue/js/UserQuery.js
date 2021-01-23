var app = new Vue({
    el:"#app",
    data:{
        address:"http://192.168.43.13:2727/",
        message:"heima",
        arrQuery:[],
        arrRes:[],
        inputValue1:"",
        inputValue2:"",
        inputValue3:"",

    },
    methods:{
        getMes:function (){
            this.arrQuery.push(this.inputValue1);
            this.inputValue1 = "";
            this.arrQuery.push(this.inputValue2);
            this.inputValue2 = "";
            this.arrQuery.push(this.inputValue3);
            this.inputValue3 = "";
            var that = this;
            axios.get(this.address+"searchTrainsByStationAndDate?depart_station="+this.arrQuery[0]+"&arr_station="+this.arrQuery[1]+"&date="+this.arrQuery[2])
                .then(function (response){
                        console.log(response);
                        that.arrRes = response.data;
                    },
                )
                .catch(function (err){})
        },

        add1:function () {
            this.arrQuery.push(this.inputValue1);
            this.inputValue1 = "";
        },
        add2:function () {
            this.arrQuery.push(this.inputValue2);
            this.inputValue2 = "";
        },
        add3:function () {
            this.arrQuery.push(this.inputValue3);
            this.inputValue3 = "";
        },
        clear:function (){
            this.arrQuery = [];
            this.arrRes = [];
            this.inputValue1 = "";
            this.inputValue2 = "";
            this.inputValue3 = "";

        },
        addstation:function (station){
            this.arrQuery.push(station);
        }
    },
})

laydate.render({
    elem: '#test1'
    ,theme: 'molv'
    ,format:'yyyy-MM-dd'
});