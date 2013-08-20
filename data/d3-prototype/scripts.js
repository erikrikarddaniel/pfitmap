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
	columns_names : [],
	taxa_names : ["domain", "kingdom","phylum", "class", "order", "family", "genus", "species", "strain"],
	taxa_level : "strain",	
	protein_names : []
	
};
var tmp_nest;

function load_data() {
	d3.tsv("column_matrix_top_protein_level.tsv", function(data) {
	pfitmap.dataset = data;
	for (var attrib in pfitmap.dataset[0]) {		
		//if (k.startsWith("protein")) {pfitmap.protein_names.push(k.split(":").slice(1)); };
		if (attrib.startsWith("protein")) {  
			attrib = getProteinName(attrib); 
			if (pfitmap.protein_names.indexOf(attrib)==-1) {
				pfitmap.protein_names.push(attrib);
			}
		};
		if (pfitmap.columns_names.indexOf(attrib)==-1) {
			pfitmap.columns_names.push(attrib);
		}
	};
	
	for (var i in pfitmap.dataset) {
		organism = pfitmap.dataset[i];
		
		for (attrib in organism) {
			if (attrib.startsWith("protein")) {
				p_name = getProteinName(attrib);
				p_type = attrib.split(":").slice(-1);
				if (!organism.hasOwnProperty(p_name)) {
					organism[p_name] = {};
				}
				organism[p_name][p_type] = organism[attrib];
			}
		} 		
	}
	pfitmap.organisms_count = pfitmap.dataset.length;
	pfitmap.svg_height = (pfitmap.organisms_count + 1) * pfitmap.row_height;
	pfitmap.svg_width = (pfitmap.columns_names.length * pfitmap.column_width);
	table_it();
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
	var table = d3.select("#heat_map")
		.append("table");
		
	var thead = table.append("thead");
	var tbody = table.append("tbody");
	
	thead.append("tr")
		.selectAll("th")
		.data(pfitmap.columns_names)
		.enter()
		.append("th")
		.text(function(column) { return column;})
	var rows = tbody.selectAll("tr")
		.data(pfitmap.dataset)
		.enter()
		.append("tr");
		
	var cells = rows.selectAll("td")
		.data(function(row) {
			return pfitmap.columns_names.map(function(column) {
				if (pfitmap.protein_names.indexOf(column) != -1){ return { column: column, value: [row[column]["n_proteins"], row[column]["n_genomes_w_protein"]].join(" | ") } }
				else { return {column: column, value: row[column]} }
			})		
		})
		.enter()
		.append("td")
		.text(function(d) { return d.value; });
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
	var ind = pfitmap.taxa_names.indexOf(level);
	if (level == "domain") {
		var nest = d3.nest()
			.key(function(d) { return d["domain"]})
/*			.rollup(function(d) { return {
					n_genomes : d3.sum(d,function(g) {return +g["n_genomes"]}),
					proteins : pfitmap.protein_names.map(function(protein) { return d3.sum(d,function(g) {return +g[protein]; } ) } )
				}
			})*/
			.map(pfitmap.dataset,d3.map)
			//.entries(pfitmap.dataset);
	} else if (level == "kingdom") {
		var nest = d3.nest()
			.key(function(d) { return d["domain"]})
			.key(function(d) {return d["kingdom"]})
			.rollup(function(d) { return {
					n_genomes : d3.sum(d,function(g) {return +g["n_genomes"]}),
					proteins : pfitmap.protein_names.map(function(protein) { return d3.sum(d,function(g) {return +g[protein]; } ) } )
				}
			})
			.map(pfitmap.dataset,d3.map)
			//.entries(pfitmap.dataset);
	} else if (level == "phylum") {
		var nest = d3.nest()
			.key(function(d) { return d["domain"]})
			.key(function(d) {return d["kingdom"]})
			.key(function(d) {return d["phylum"]})
			.rollup(function(d) { return { 
					n_genomes : d3.sum(d,function(g) {return +g["n_genomes"]}),
					proteins : pfitmap.protein_names.map(function(protein) { return d3.sum(d,function(g) {return +g[protein]; } ) } )
				}
			})
			.entries(pfitmap.dataset);
	} else if (level == "strain") {
		var nest = d3.nest()
			.key(function(d) { return d["domain"]})
			.key(function(d) {return d["kingdom"]})
			.key(function(d) {return d["phylum"]})
			.key(function(d) {return d["class"]})
			.key(function(d) {return d["order"]})
			.key(function(d) {return d["family"]})
			.key(function(d) {return d["genus"]})
			.key(function(d) {return d["species"]})
			.key(function(d) {return d["strain"]})
			.rollup(function(d) { return {
					n_genomes : d3.sum(d,function(g) {return +g[n_genomes]}),
					proteins : pfitmap.protein_names.map(function(protein) { return d3.sum(d,function(g) {return +g[protein]; } ) } )
				}
			})
			.entries(pfitmap.dataset);
	};
	console.log(nest);
	tmp_nest = nest
};
function sum_protein(level) {
	console.log(level);
};

function sumArrays(group) {
  return group.reduce(function(prev, cur, index, arr) {
    return {
      values: prev.values.map(function(d, i) {
        return d + cur.values[i];
      })
    };
  });
}

function getProteinName(protein) {
	return protein.split(":").slice(1,-1).join(":")
}
