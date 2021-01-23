var app = new Vue({
    el:"#app",
    data:{
        address:"http://192.168.43.13:2727/",
        message:"heima",
        arrQuery:[],
        arrRes:[],
        inputValue1:"",
        inputValue2:"",

    },
    methods:{
        getMes:function (){
            this.arrQuery.push(this.inputValue1);
            this.inputValue1 = "";
            this.arrQuery.push(this.inputValue2);
            this.inputValue2 = "";
            var that = this;
            axios.get(this.address+"searchTrainsByNumAndDate?train_num="+this.arrQuery[0]+"&date="+this.arrQuery[1])
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
        clear:function (){
            this.arrQuery = [];
            this.arrRes = [];
            this.inputValue = "";
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