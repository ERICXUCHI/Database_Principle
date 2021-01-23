var app = new Vue({
    el:"#app",
    data:{
        message:"heima",
        arrInfo:[],
        inputValue:"",
    },
    methods:{
        getMes:function() {
            var that = this;
            axios.get("http://localhost:8080/train?dpt="+this.inputValue+"&arr="+this.inputValue+"&date="+this.inputValue)
                .then(function (response){
                        console.log(response);
                        that.arrInfo = response.data;
                    },
                )
                .catch(function (err){})
        },
        add:function () {
            this.arrInfo.push(this.inputValue);
            this.inputValue = "";
        },
        clear:function (){
            this.arrInfo = [];
            this.inputValue = "";
        },

    },
})