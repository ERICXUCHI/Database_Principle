var app = new Vue({
    el:"#app",
    data:{
        city:"",
        inputValue:"",
        arr:[],
    },
    methods:{
        getWeather:function (){
            // console.log("天气查询");
            // console.log(this.city);
            var that = this;
            axios.get("https://wthrcdn.etouch.cn/weather_mini?city="+that.city)
                .then(function (response){
                    console.log(response);
                    console.log(response.data.data.forecast);
                    that.arr = response.data.data.forecast;
                    // that.inputValue = response.data.data.city;
                })
                .catch(function (err){})
        },

        changeCity:function (city){
            this.city = city;
            this.getWeather();
        },
        getInfo:function (){
            axios.get("http://localhost//")
        }
    }
})