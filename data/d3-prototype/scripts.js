/**
 * @author Brynjar Smari Bjarnason
 */
var dataset;

function load_data() {
	d3.tsv("column_matrix_top_protein_level.tsv", function(data) {
	dataset = data;
	table_it();
	});
};

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
	console.log(dataset[0].no_genomes)
};
function sum_protein(level) {
	alert(level);
};
