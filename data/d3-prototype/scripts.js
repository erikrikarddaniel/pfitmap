/**
 * @author Brynjar Smari Bjarnason
 */
function div_bar() {
	var dataset;
	d3.tsv("d3-prototype.static_matrix.n100.tsv", function(data) {
		dataset = data;
		console.log(dataset);
		d3.select("body").selectAll("div")
			.data(dataset)
			.enter()
			.append("div")
			.attr("class","bar")
			.style("height",function(d) {var bar_height = d.no_proteins * 10; return bar_height + "px"});
	});
};
function sum_organism(level) {
	alert(level);
};
