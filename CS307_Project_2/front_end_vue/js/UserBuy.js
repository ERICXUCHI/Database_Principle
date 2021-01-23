

var app = new Vue({
    el:"#app",
    data:{
        address:"http://192.168.43.13:2727/",
        arrticket:[],
        arruser:[],
        a:[],
        inputValue:"",
        in1:"",
        in2:"",
        in3:"",
        in4:"",
        in5:"",
        in6:"",
        in7:"",
        in8:"",
    },

    methods:{
        add1:function () {
            this.arrticket.push(this.in1);
        },
        add2:function () {
            this.arrticket.push(this.in2);
        },
        add3:function () {
            this.arrticket.push(this.in3);
        },
        add4:function () {
            this.arrticket.push(this.in4);

        },
        add5:function () {
            this.arrticket.push(this.in5);

        },
        add6:function () {
            this.arruser.push(this.in6);

        },
        add7:function () {
            this.arruser.push(this.in7);

        },
        add8:function () {
            this.arruser.push(this.in8);

        },
        clearall:function (){
            this.arrticket = [];
            this.arruser = [];
            this.in1 = "";
            this.in2 = "";
            this.in3 = "";
            this.in4 = "";
            this.in5 = "";
            this.in6 = "";
            this.in7 = "";
            this.in8 = "";
        },
        postMes:function (){
            this.arrticket.push(this.in1);
            this.arrticket.push(this.in2);
            this.arrticket.push(this.in3);
            this.arrticket.push(this.in4);
            this.arrticket.push(this.in5);
            this.arruser.push(this.in6);
            this.arruser.push(this.in7);
            this.arruser.push(this.in8);


            var that = this;
            axios.get(this.address+"buyTicket?"+"train_num="+this.arrticket[0]+"&depart_station_index="+this.arrticket[1]+
            "&arr_station_index="+this.arrticket[2]+"&dpt_date="+this.arrticket[3]+"&seat_type="+this.arrticket[4]+"&user_name="+
            this.arruser[0]+"&id_card_num="+this.arruser[1]+"&phone_number="+this.arruser[2])
                .then(function (response){
                        console.log(response);
                        alert(response.data);
                        // that.a = response.data;
                    },
                )
                .catch(function (err){})
        },
    },
})
laydate.render({
    elem: '#test1'
    ,theme: 'molv'
    ,format:'yyyy-MM-dd'
});
