var app = new Vue({
    el:"#app",
    data:{
        address:"http://192.168.43.13:2727/",
        arrbuy:[],
        addStation:[],
        delStation:[],
        addTrain:[],
        delTrain:[],
        addstation:"",
        delstation:"",
        addtrain:[],
        deltrain:[]
    },
    methods:{
        addingstation:function (){
            this.addStation.push(this.addstation);
            var that = this;
            axios.get(this.address+"addStationByName?add_station_name="+this.addStation[0])
                .then(function (response){
                        console.log(response);
                        alert(response.data)
                    },
                )
                .catch(function (err){})
        },
        deletingstation:function (){
            this.delStation.push(this.delstation);
            var that = this;
            axios.get(this.address+"deleteStationByName?del_station_name="+this.delStation[0])
                .then(function (response){
                        console.log(response);
                        alert(response.data)
                    },
                )
                .catch(function (err){})
        },
        addingtrain:function (){
            var that = this;
            this.addTrain.push(this.addtrain[0]);
            this.addTrain.push(this.addtrain[1]);
            this.addTrain.push(this.addtrain[2]);
            this.addTrain.push(this.addtrain[3]);
            this.addTrain.push(this.addtrain[4]);
            this.addTrain.push(this.addtrain[5]);
            this.addTrain.push(this.addtrain[6]);
            this.addTrain.push(this.addtrain[7]);
            this.addTrain.push(this.addtrain[8]);
            this.addTrain.push(this.addtrain[9]);
            this.addTrain.push(this.addtrain[10]);
            this.addTrain.push(this.addtrain[11]);

            axios.get(this.address+"addTrain?add_train_num="+this.addTrain[0]+"&add_dpt_date="+this.addTrain[1]+
            "&add_station_name="+this.addTrain[2]+"&add_arr_time="+this.addTrain[3]+"&add_dpt_time="+this.addTrain[4]+
            "&add_arr_day="+this.addTrain[5]+"&add_entrance="+this.addTrain[6]+"&add_interval_km="+this.addTrain[7]+
            "&add_first_price="+this.addTrain[8]+"&add_second_price="+this.addTrain[9]+"&add_first_remain="+this.addTrain[10]
            +"&add_second_remain="+this.addTrain[11])
                .then(function (response){
                        console.log(response);
                        alert(response.data)
                    },
                )
                .catch(function (err){})
        },
        deletingtrain:function (){

            var that = this;
            this.delTrain.push(this.deltrain[0]);
            this.delTrain.push(this.deltrain[1]);
            axios.get(this.address+"deleteTrainByNumAndDate?train_num="+this.delTrain[0]+"&date="+this.delTrain[1])
                .then(function (response){
                        console.log(response);
                        alert(response.data)
                    },
                )
                .catch(function (err){})
        },
        addStation1:function () {
            this.addStation.push(this.addstation);

        },
        delStation1:function () {
            this.delStation.push(this.delstation);
        },
        addTrain1:function (i) {
            this.addTrain.push(this.addtrain[i]);

        },
        delTrain1:function (i) {
            this.delTrain.push(this.deltrain[i]);

        },
        clear:function (){
            this.arrbuy = [];
            this.inputValue = "";
        },
    },
})
laydate.render({
    elem: '#test1'
    , theme: 'molv'
    , format: 'yyyy-MM-dd'
});
laydate.render({
    elem: '#test2'
    , theme: 'molv'
    , format: 'yyyy-MM-dd'
});