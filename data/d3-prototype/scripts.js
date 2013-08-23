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
	circos_matrix : [],
	taxa_names : ["domain", "kingdom","phylum", "class", "order", "family", "genus", "species", "strain"],
	taxa_level : "domain",
	base_data_file : "column_matrix_top_protein_level.tsv"
};

var colorLow = 'white', colorMed = 'yellow', colorHigh = 'red';
  
var colorScale = d3.scale.linear()
     .domain([0, 0.5, 1])
     .range([colorLow, colorMed, colorHigh]);


function load_data(query) {
	pfitmap.columns_names = [];
	pfitmap.proteins_names = [];

	d3.tsv(query, function(data) {
	pfitmap.dataset = data;
	for (var attrib in pfitmap.dataset[0]) {		
		//if (k.startsWith("protein")) {pfitmap.proteins_names.push(k.split(":").slice(1)); };
		if (attrib.startsWith("protein")) {  
			attrib = getProteinName(attrib); 
			if (pfitmap.proteins_names.indexOf(attrib)==-1) {
				pfitmap.proteins_names.push(attrib);
			}
		};
		
		if (pfitmap.columns_names.indexOf(attrib)==-1) {
			pfitmap.columns_names.push(attrib);
		}
	};

	d3.select("#taxa_selector").select("ul").remove();
	d3.select("#taxa_selector").append("ul")
		.selectAll("li")
		.data(pfitmap.taxa_names)		
		.enter()
		.append("li")
		.append("a")
		.attr("href", function(d) {return ["javascript:get_taxa('",d.split(" ").join("_").toLowerCase(),"')"].join(""); })
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
	pfitmap.circos_matrix = [];
	d3.select("#heat_map").select("table").remove();
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
	var nr_rows = rows[0].length;
	var matrix_size = rows[0].length + pfitmap.proteins_names.length;
	for (var i = 0; i<matrix_size;i++) {
		pfitmap.circos_matrix[i] =  Array.apply(null, new Array(matrix_size)).map(Number.prototype.valueOf,0);
	}
	
	var cells = rows.selectAll("td")
		.data(function(row,i) {
			
			return pfitmap.columns_names.map(function(column) {
				var protein_ind = pfitmap.proteins_names.indexOf(column);
				if (protein_ind != -1){ pfitmap.circos_matrix[i][nr_rows+protein_ind] = +row[column]["n_genomes_w_protein"];pfitmap.circos_matrix[nr_rows+protein_ind][i] = +row[column]["n_genomes_w_protein"]; return { column: column, value: row[column], value_text: [row[column]["n_genomes_w_protein"],row[column]["n_proteins"]].join(" | ") } }
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

function get_enzyme(level) {
	var query = ["column_matrix_",level,".tsv"].join("")
	load_data(query);
};

function get_taxa(level) {
	var query

	if ([null,"strain"].indexOf(level) != -1) {
		query = ["column_matrix_","top","_protein_level.tsv"].join("");
	}
	else {
		query = ["column_matrix_",level,"_protein_level.tsv"].join("");
	}
	load_data(query);
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

function generate_circos() {
var chord = d3.layout.chord()
    .padding(.05)
    .sortSubgroups(d3.descending)
    .matrix(pfitmap.circos_matrix);

var width = 960,
    height = 500,
    innerRadius = Math.min(width, height) * .41,
    outerRadius = innerRadius * 1.1;

var range9 = ["#000000", "#33585e", "#957244", "#F26223", "#155420", "#FF0000","#FFFF00","#FF00FF","#00FFFF"] 
var fill = d3.scale.ordinal()
    .domain(d3.range(range9.length))
    .range(range9);

var svg = d3.select("#circos_svg").append("svg")
    .attr("width", width)
    .attr("height", height)
  .append("g")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

svg.append("g").selectAll("path")
    .data(chord.groups)
  .enter().append("path")
    .style("fill", function(d) { return fill(d.index); })
    .style("stroke", function(d) { return fill(d.index); })
    .attr("d", d3.svg.arc().innerRadius(innerRadius).outerRadius(outerRadius))
    .on("mouseover", fade(.1))
    .on("mouseout", fade(1));
/*
var ticks = svg.append("g").selectAll("g")
    .data(chord.groups)
  .enter().append("g").selectAll("g")
    .data(groupTicks)
  .enter().append("g")
    .attr("transform", function(d) {
      return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
          + "translate(" + outerRadius + ",0)";
    });

ticks.append("line")
    .attr("x1", 1)
    .attr("y1", 0)
    .attr("x2", 5)
    .attr("y2", 0)
    .style("stroke", "#000");

ticks.append("text")
    .attr("x", 8)
    .attr("dy", ".35em")
    .attr("transform", function(d) { return d.angle > Math.PI ? "rotate(180)translate(-16)" : null; })
    .style("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
    .text(function(d) { return d.label; });
*/
svg.append("g")
    .attr("class", "chord")
  .selectAll("path")
    .data(chord.chords)
  .enter().append("path")
    .attr("d", d3.svg.chord().radius(innerRadius))
    .style("fill", function(d) { return fill(d.target.index); })
    .style("opacity", 1);

}

// Returns an array of tick angles and labels, given a group.
function groupTicks(d) {
  var k = (d.endAngle - d.startAngle) / d.value;
  return d3.range(0, d.value, 1000).map(function(v, i) {
    return {
      angle: v * k + d.startAngle,
      label: i % 5 ? null : v / 1000 + "k"
    };
  });
}

// Returns an event handler for fading a given chord group.
function fade(opacity) {
  return function(g, i) {
    svg.selectAll(".chord path")
        .filter(function(d) { return d.source.index != i && d.target.index != i; })
      .transition()
        .style("opacity", opacity);
  };
}