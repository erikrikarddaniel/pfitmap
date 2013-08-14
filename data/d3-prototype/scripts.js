/**
 * @author Brynjar Smari Bjarnason
 */
var pfitmap = {
	dataset : null,
	svg_height : null,
	svg_width : null,
	row_height : 25,
	column_width : 25, 
	organisms_count : null,
	columns_names : []
};

function load_data() {
	d3.tsv(" column_matrix_top_protein_level.tsv", function(data) {
	pfitmap.dataset = data;
	for (var k in pfitmap.dataset[0]) {
		pfitmap.columns_names.push(k);
	};
	pfitmap.organisms_count = pfitmap.dataset.length;
	pfitmap.svg_height = (pfitmap.organisms_count + 1) * pfitmap.row_height;
	pfitmap.svg_width = (pfitmap.columns_names.length * pfitmap.column_width);
	svg_it();
	});
};
  
function svg_it() {
	var colorScale = d3.scale.linear()
     						 .domain([0, 1, 2])
     						 .range(["green", "yellow", "red"]);
	var svg = d3.select("#heat_map").append("svg")
					.attr("width", pfitmap.svg_width)
					.attr("height", pfitmap.svg_height);
/*					.append("svg:rect")
					.attr("x", 0)
					.attr("y", 0)
					.attr("width",pfitmap.svg_width)
					.attr("height",pfitmap.svg_height)
					.style("fill","orange");
*/					
	var heat_map = svg.selectAll(".heatmap")
    						.data(pfitmap.dataset, function(d, index) { return index + " : " + d; })
  							.enter().append("svg:rect")
    						.attr("x", function(d) { return 0; })
    						.attr("y", function(d) { return d.index*pfitmap.row_height; })
    						.attr("width", function(d) { return pfitmap.svg_width; })
    						.attr("height", function(d) { return pfitmap.row_height; })
    						.style("fill", function(d) { return colorScale(d.n_genomes); })
}

function table_it() {
	console.log(dataset);
	var tr = d3.select("body").append("table").selectAll("tr").data(dataset).enter().append("tr");
	var td = tr.selectAll("td").data(function(d) {return [d.n_genomes, d["protein:RNR I:NrdA:n_proteins"], d["protein:RNR I:NrdA:n_genomes_w_protein"], d["protein:RNR I:NrdB:n_proteins"], d["protein:RNR I:NrdB:n_genomes_w_protein"], d["protein:RNR III:NrdD:n_proteins"], d["protein:RNR III:NrdD:n_genomes_w_protein"], d["protein:RNR III:NrdG:n_proteins"], d["protein:RNR III:NrdG:n_genomes_w_protein"],d["protein:RNR II:NrdJ:n_proteins"],d["protein:RNR II:NrdJ:n_genomes_w_protein"] ]; }).enter().append("td").text(function(d) { return d; });
}


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
	console.log(pfitmap.dataset[0].n_genomes)
};
function sum_protein(level) {
	console.log(level);
};
