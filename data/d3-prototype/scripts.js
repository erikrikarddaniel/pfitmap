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
	proteins_names : [],
	enzyme_names : [],
	taxa_names : ["domain", "kingdom","phylum", "class", "order", "family", "genus", "species", "strain"],
	taxa_level : "domain",
	base_data_file : "column_matrix_top_protein_level.tsv"
};

var colorLow = 'white', colorMed = 'yellow', colorHigh = 'red';
  
var colorScale = d3.scale.linear()
     .domain([0, 0.5, 1])
     .range([colorLow, colorMed, colorHigh]);


function load_data(level) {
	pfitmap.columns_names = [];
	pfitmap.proteins_names = [];
	if ([null,"strain"].indexOf(level) != -1) {
		datafile = ["column_matrix_","top","_protein_level.tsv"].join("");
	}
	else {
		datafile = ["column_matrix_",level,"_protein_level.tsv"].join("");
	}

	d3.tsv(datafile, function(data) {
	pfitmap.dataset = data;
	for (var attrib in pfitmap.dataset[0]) {		
		//if (k.startsWith("protein")) {pfitmap.proteins_names.push(k.split(":").slice(1)); };
		if (attrib.startsWith("protein")) {  
			attrib = getProteinName(attrib); 
			if (pfitmap.proteins_names.indexOf(attrib)==-1) {
				pfitmap.proteins_names.push(attrib);
			}
			var enzyme = attrib.split(":")[0];
			if (pfitmap.enzyme_names.indexOf(enzyme) == -1) {
				pfitmap.enzyme_names.push(enzyme);
			}
		};
		
		if (pfitmap.columns_names.indexOf(attrib)==-1) {
			pfitmap.columns_names.push(attrib);
		}
	};
	
	d3.select("#protein_selector").select("ul").remove();
	d3.select("#protein_selector").append("ul")
		.selectAll("li")
		.data(pfitmap.enzyme_names)		
		.enter()
		.append("li")
		.append("a")
		.attr("onClick", function(d) {return ["sum_protein('",d.split(" ").join("_").toLowerCase(),"')"].join(""); })
		.text(function(d) { return d });
	d3.select("#organism_selector").select("ul").remove();
	d3.select("#organism_selector").append("ul")
		.selectAll("li")
		.data(pfitmap.taxa_names)		
		.enter()
		.append("li")
		.append("a")
		.attr("onClick", function(d) {return ["load_data('",d.split(" ").join("_").toLowerCase(),"')"].join(""); })
		.text(function(d) { return d });
		
	
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
				organism[p_name]["n_genomes"] = organism["n_genomes"]	
			}
		} 		
	}
	pfitmap.organisms_count = pfitmap.dataset.length;
	pfitmap.svg_height = (pfitmap.organisms_count + 1) * pfitmap.row_height;
	pfitmap.svg_width = (pfitmap.columns_names.length * pfitmap.column_width);
	table_it();
	});
};

function table_it() {
	d3.select("#heat_map").select("table").remove()
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
				if (pfitmap.proteins_names.indexOf(column) != -1){ return { column: column, value: row[column], value_text: [row[column]["n_proteins"], row[column]["n_genomes_w_protein"]].join(" | ") } }
				else { return {column: column, value_text: row[column]} }
			})		
		})
		.enter()
		.append("td")
		.style("background-color",function(d) { if (d.hasOwnProperty("value")) { return colorScale(d.value.n_genomes_w_protein/ d.value.n_genomes);} else {return "None"; }})
		.text(function(d) { return d.value_text; });
}


function div_bar() {
	d3.select("body").selectAll("div")
		.data(dataset)
		.enter()
		.append("div")
		.attr("class","bar")
		.style("height",function(d) {var bar_height = d.no_proteins * 10; return bar_height + "px"});
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
