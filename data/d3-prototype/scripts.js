/**
 * @author Brynjar Smari Bjarnason
 */
var dataset;

function load_data() {
	d3.tsv("d3-prototype.static_matrix.n100.tsv", function(data) {
	dataset = data;
	});
};


function div_bar() {
	d3.select("body").selectAll("div")
		.data(dataset)
		.enter()
		.append("div")
		.attr("class","bar")
		.style("height",function(d) {var bar_height = d.no_proteins * 10; return bar_height + "px"});
};
function sum_organism(level) {
	console.log(level);
	console.log(dataset[0].no_genomes)
};
function sum_protein(level) {
	alert(level);
};
