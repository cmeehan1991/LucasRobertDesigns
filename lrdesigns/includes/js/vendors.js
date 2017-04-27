$(document).ready(function(){
	// Get the endpoint/location and type (csv, xls(x), or api)
	var vendorListEndPoint = $('.endpoint').data('endpoint');
	var vendorListType = $('.endpoint').data('type');
	
	switch(vendorListType){
		case 'CSV': 
			console.log('csv');
			getList(vendorListEndPoint, "csv");
			break;
		case 'XLS/X': 
			getList(vendorListEndPoint, "xlsx");
			break;
		case 'API': 
			console.log('api');
			break;
		default: 
			break;
	}
})

function getList(endPoint, type){
	console.log(endPoint);
	$.ajax({
		url: endPoint, 
		type: "get", 
		dataType: "text",
		success:function(data){
			// Set the list variables
			var element = "vendor-list-wrap";
			var options = {
				item: "<li><span class='vendor'></span><br/><span class='address1'></span><span class='address2'></span><br/><span class='city'></span>, <span class='state'></span> <span class='zip'></span><br/><span class='phone'></span><br/><span class='url'></span><br/><img src='http://wpdev.lucasrobertdesigns.com/wp-content/uploads/2017/03/divider-29115_1280.png' class='vendor-separator' alt='separator'/></li>",
				valueNames:["vendor", "address1",'address2','city','state','zip','phone','url'],
				page:25,
				pagination:true,
				plugins: [
					ListFuzzySearch(),
					ListPagination({
						name: "pagination", 
						paginationClass: "pagination",
						innerWindow: 2, 
						outerWindow: 1
						})
				]
			}	
			var results = $.csv.toObjects(data);
			var vendors = []
			for (var i = 0; i <= results.length; i++){
				vendors.push(results[i]);
			}	
			vendors.pop();
			new List(element, options, vendors);
		},
		error: function(error){
			console.log("Error: " + error)
		}
	});
}