$(document).ready(function(){
  if (typeof gon != typeof undefined) {
    gon.dataset = JSON.parse(gon.cm);
    gon.taxons = gon.dataset.taxons;
    gon.taxa_color = d3.scale.category20();
    params = getParameters();
    gon.params = params;

    if (!gon.params["view_menu"] || gon.params["view_menu"] == "matrix") {
      d3_make_table();
    }
    else if (gon.params["view_menu"] == "circos") {
      d3_make_circos();
    }
  }
});

function d3_reload_page() {
  window.location.search = $.param(gon.params);
}

function d3_toggle_zeros() {
  if (!gon.zeros_proteins) {
    gon.zeros_proteins = [];
    for (var i in gon.prot_columns) { 
      protein = $("."+gon.prot_columns[i].replace(".","\\.").replace("/","\\/").split(" ").join(".")+".heat_label");
      var sum = 0;
      protein.each(function() { sum += Number($(this).text()) });
      if (sum == 0) {
	gon.zeros_proteins.push("."+gon.prot_columns[i].replace(".","\\.").replace("/","\\/").split(" ").join("."));
      }
    }
  }
  if (!gon.zeros_taxons) {
    gon.zeros_taxons = [];
    var taxons = gon.taxons.map(function(d) {return d[gon.dataset.taxon_level]})
    for (var i in taxons) {
      taxon = $("."+taxons[i].replace(".","\\.").replace("/","\\/").split(" ").join(".")+" td.heat_label")
      var sum = 0;
      taxon.each(function() { sum += Number($(this).text()) });
      if (sum == 0) {
	gon.zeros_taxons.push("."+taxons[i].replace(".","\\.").replace("/","\\/").split(" ").join("."));
      }
    }
  }
  console.log(gon.zeros_taxons);
  console.log(gon.zeros_proteins);
  if ($(gon.zeros_proteins[0]).is(":visible") || $(gon.zeros_taxons[0]).is(":visible") ) {
    for (var i in gon.zeros_proteins) {
      $(gon.zeros_proteins[i]).hide();
    }
    for (var i in gon.zeros_taxons) {
      $(gon.zeros_taxons[i]).hide();
    }
  }
  else {
    for (var i in gon.zeros_proteins) {
      $(gon.zeros_proteins[i]).show();
    }
    for (var i in gon.zeros_taxons) {
      $(gon.zeros_taxons[i]).show();
     }

  }
}

function d3_make_circos() {
  d3.select("#circos").select("svg").remove();
  d3_prep_circos_dataset();
  d3_circos_it(gon.circos_matrix);
}

function d3_prep_circos_dataset(){
  gon.circos_matrix = [];
  gon.circos_columns = gon.taxons.map(function(d) {return d[gon.dataset.taxon_level];}).concat(gon.prot_columns);
  gon.circos_matrix_size = gon.circos_columns.length;
  for ( var i = 0; i < gon.circos_matrix_size; i++ ) {
    gon.circos_matrix[i] = Array.apply(null, new Array(gon.circos_matrix_size)).map(Number.prototype.valueOf,0);
  }
  gon.taxons.forEach(function(tax) {
    tax_ind = gon.circos_columns.indexOf(tax[gon.dataset.taxon_level]);
    tax.proteins.forEach(function(prot) {
      prot_ind = gon.circos_columns.indexOf(prot[gon.dataset.protein_level]);
      gon.circos_matrix[tax_ind][prot_ind] = +prot.no_genomes_with_proteins
      gon.circos_matrix[prot_ind][tax_ind] = +prot.no_genomes_with_proteins
    });
  });
}

function d3_circos_it(matrix) {

  var w = 600,
    h = 600,
    r1 = Math.min(w, h) / 2 - 4,
    r0 = r1 - 20,
    format = d3.format(",.3r");

  var layout = d3.layout.chord()
    .padding(.04)
    .matrix(matrix);

  var fill = d3.scale.ordinal()
    .domain(d3.range(gon.taxa_color.range().length))
    .range(gon.taxa_color.range());

  var arc = d3.svg.arc()
    .innerRadius(r0)
    .outerRadius(r1);

  var chord = d3.svg.chord()
    .radius(r0);

  var svg = d3.select("#circos").append("svg:svg")
    .attr("width", w)
    .attr("height", h)
    .append("svg:g")
    .attr("transform", "translate(" + w / 2 + "," + h / 2 + ")");

  svg.selectAll("path.chord")
    .data(layout.chords)
    .enter().append("svg:path")
    .attr("class","chord")
    .attr("d", chord)
    .style("fill", function(d) { return fill(d.target.index); })
    .style("stroke", function(d) { return d3.rgb(fill(d.target.index)).darker(); })
    .append("svg:title")
    .text(function(d) { return "Source: " + gon.circos_columns[d.source.index]+ " Target: " + gon.circos_columns[d.target.index]})


  var g = svg.selectAll("g.group")
    .data(layout.groups)
    .enter()
    .append("svg:g")
    .attr("class","group");

  g.append("svg:path")
    .style("fill",function(d) { return fill(d.index)})
    .attr("id", function (d, i) { return "group" + d.index })
    .attr("d",arc)
    .on("mouseover", fade(.1))
    .on("mouseout", fade(1))
    .append("svg:title")
    .text(function(d) { return gon.circos_columns[d.index]; });

  g.append("svg:text")
    .attr("x",6)
    .attr("dy",15)
//    .filter(function(d) {  return d.value > 110; } )
    .append("svg:textPath")
    .attr("xlink:href", function(d) {return "#group"+d.index; })
    .text(function(d) { return gon.circos_columns[d.index]; });


}

// Returns an event handler for fading a given chord group.
function fade(opacity) {
  return function(g, i) {
    svg = d3.select("#circos").select("svg");
    svg.selectAll(".chord")
      .filter(function(d) { return d.source.index != i && d.target.index != i; })
      .transition()
      .style("opacity", opacity);
  };
}

function d3_make_table() {
  d3.select("#heat_map").select("table").remove();
  d3_prep_table_dataset();
  d3_table_it(gon.taxons);
  //Put borders around selected rows
  $('input[name=tax_filter]').change(function() {
    d3_table_bordering();
  });

  $('input[name=prot_filter]').change(function() {
    d3_table_bordering();
  });

}

function d3_table_bordering() {
  $(".active-taxon").removeClass("active-taxon")
  $(".active-protein").removeClass("active-protein")
  var t = $("input[name=tax_filter]:checked").closest('tr');
  var psel = $("input[name=prot_filter]:checked").map(function(d) {return "."+this.value })
  var p = psel.map(function(d) { return $(psel[d])} )
  if ( t.length && p.length ) { 
    t.each(function(i) { 
      var tt = $(t[i]);
      psel.each(function(j) { 
	tt.find(psel[j]).addClass("active-taxon active-protein")
      });
    });
  }  
  else if (p.length) { p.each(function(i) {$(p[i]).addClass("active-protein");}) }
  else if (t.length) { t.each(function(i) {$(t[i]).find('td').addClass("active-taxon");}) }
  
  //$("."+this.value).toggleClass("active-protein", this.checked);
}

function d3_prep_table_dataset(){
  gon.heat_color = d3.scale.linear().domain([0, 0.5, 1]).range(["white", "yellow", "red"]);
}

function d3_view_menu(view_menu) {
  gon.params["view_menu"] = encodeURI(view_menu);
  d3_reload_page();
}

function d3_color_table(level) {
  if (!level) {
    if (!gon.params["color"]) {
      level = gon.tl[0];
    }
    else {
      level = decodeURI(gon.params["color"]);
    }
  }
  level = gon.tl[Math.min(gon.tl.indexOf(gon.dataset.taxon_level),gon.tl.indexOf(level))];
  gon.params["color"] = encodeURI(level);
  var cells = d3.select("#heat_map").select("table").select("tbody").selectAll("tr").selectAll("td");
  cells.style("background-color",function(d) {if (d.hasOwnProperty("ratio")){return gon.heat_color(d.ratio)}  })

  var tr = d3.selectAll(".taxon_label").style("background-color",function(d) {return gon.taxa_color(d[level]);} ) 
}

function d3_database(db) {
  // Filter on different databases. Puts parameter db in url
  gon.params["db"] = encodeURI(db);
  d3_reload_page();
}

function d3_taxon_level(level) {
  // Select specific taxa level. If there is filtering on lower levels in the hierarchy we delete that filtering.
  var p = d3_protein_filter();
  var t = d3_taxon_filter();
  if (p != null) {
    gon.params[gon.dataset.protein_level] = p;
  }
  if (t != null) {
    gon.params[gon.dataset.taxon_level] = t;
  }
  gon.params["taxon_level"] = encodeURI(level);
  for (var i = gon.tl.indexOf(level) + 1; i < gon.tl.length; i++) {delete gon.params[gon.tl[i]];}
  d3_reload_page();
}

function d3_protein_level(level) {
  // Select specific protein level. If there is filtering on lower levels in the hierarchy we delete that filtering.
  var p = d3_protein_filter();
  var t = d3_taxon_filter();
  if (p != null) {
    gon.params[gon.dataset.protein_level] = p;
  }
  if (t != null) {
    gon.params[gon.dataset.taxon_level] = t;
  }
  gon.params["protein_level"] = encodeURI(level);
  for (var i = gon.pl.indexOf(level) + 1; i < gon.pl.length; i++) {delete gon.params[gon.pl[i]];}
  d3_reload_page();
}

function d3_filter_table(filter) {
  // Filter on selected taxa and protein
  var p = d3_protein_filter();
  var t = d3_taxon_filter();
  if (p != null) {
    gon.params[gon.dataset.protein_level] = p;
  }
  if (t != null) {
    gon.params[gon.dataset.taxon_level] = t;
  }
  d3_reload_page();
}

function d3_clear_filters(filter) {
  if (filter == "clear_proteins" || filter == "clear_all")
  {
    gon.protein_levels.forEach(function(l) {
      delete gon.params[l];
    });
  }
  if (filter == "clear_taxa" || filter == "clear_all")
  {
    gon.taxon_levels.forEach(function(l) {
      delete gon.params[l];
    });
  }
  d3_reload_page()
}

function d3_taxon_filter() {
  var tfilter = d3.selectAll("input[name=tax_filter]:checked")[0];
  var t = tfilter.map(function(d) {return d.value});
  var result = null;
  if (t.length > 0) {
    result = encodeURI(t.join("(,)"));
  }
  return result
}

function d3_protein_filter() {
  var pfilter = d3.selectAll("input[name=prot_filter]:checked")[0];
  var p = pfilter.map(function(d) {return d.value});
  var result = null;
  if (p.length > 0) { 
    result = encodeURI(p.join("(,)"));
  }
  return result
}

function d3_table_it(dataset) {
    var table = d3.select("#heat_map")
        .append("table")
        .attr("class","count_matrix");
    
    var thead = table.append("thead");
    var tbody = table.append("tbody");
    
    var head = thead.append("tr").selectAll("td")
        .data(gon.columns)
        .enter()
        .append("td")
        .attr("class", function(d) { if(gon.prot_columns.indexOf(d) != -1) {return "protein_label "+d;} else {return null;} } )
        .text(function(d) {return gon.prot_columns.indexOf(d) == -1 ? gon.column_names[d] : null} )

    var plabel = d3.selectAll(".protein_label")
        plabel.append("input").attr("type","checkbox").attr("name","prot_filter").attr("value",function(d) {return d})
        plabel.append("span").attr("class","input-group-addon").text(function(d) {return d})

    var rows = tbody.selectAll("tr")
        .data(dataset)
        .enter()
        .append("tr")
        .attr("class",function(d) {return d[gon.dataset.taxon_level] })

    var cells = rows.selectAll("td")
        .data(function(row) { 
          //create dictionary of proteins for each row:
          var proteins = row.proteins.reduce( function(obj,x) {
              obj[x[gon.dataset.protein_level]] = {no_proteins: x.no_proteins,ratio: x.no_genomes_with_proteins / row.no_genomes, no_genomes_with_proteins: x.no_genomes_with_proteins} ;
              return obj;
          },{});
          //mapping and joining on the columns in the header
          return gon.tax_columns.map( function(column) {
            return {column: column, value: row[column]}
          })
          .concat(
            gon.prot_columns.map(function(column) { 
              p = proteins[column];
              return {column: column, value: p ? p.no_proteins : 0, ratio: p ? p.ratio : 0, organism: row[gon.dataset.taxon_level], no_genomes_with_proteins: p ? p.no_genomes_with_proteins : 0 }
            })
          )
        })
        .enter()
        .append("td")
        .attr("class",function(d){ 
	  cl ="";
	  if (d.hasOwnProperty("organism") ) {
	    cl = "heat_label " + d.column;
	  }
	  else if (d.column == "no_genomes") {
	    cl = "no_genomes";
	  }
	  return cl;
	})
        .text(function(d) {if (d.column != gon.dataset.taxon_level) {return d.value} } );

    var tlabel = rows.select("td").attr("class","taxon_label")
        tlabel.append("input").attr("type","checkbox").attr("name","tax_filter").attr("value",function(d) {return d[gon.dataset.taxon_level]})
        tlabel.append("span").attr("class","input-group-addon").text(function(d) {return d[gon.dataset.taxon_level]})
    //taxon tooltip
    $(".taxon_label").tooltip({"toggle":true,"title":function () {r=[];for (var i = 0; i < gon.taxon_levels.length; i++) {r.push(this.__data__[gon.taxon_levels[i]])};return r.join("<br/>")},"placement":"left"});
    //cell tooltip
    $(".heat_label").tooltip({"toggle":true,"title":function() {return "Proteins: "+this.__data__.value+"<br/>Genomes w. proteins: "+this.__data__.no_genomes_with_proteins+"<br/>Organism: " + this.__data__.organism + "<br/>Protein: "+this.__data__.column},"placement":"bottom" })
    d3_color_table(gon.params["color"]);
}

function updateQueryStringParameter(uri, key, value) {
  var re = new RegExp("([?|&])" + key + "=.*?(&|$)", "i");
  separator = uri.indexOf('?') !== -1 ? "&" : "?";
  if (uri.match(re)) {
    return uri.replace(re, '$1' + key + "=" + value + '$2');
  }
  else {
    return uri + separator + key + "=" + value;
  }
}
function getParameters() {
  var searchString = window.location.search.substring(1)
    , params = searchString.split("&")
    , hash = {}
    ;

  if (searchString == "") return {};
  for (var i = 0; i < params.length; i++) {
    var val = params[i].split("=");
    hash[unescape(val[0])] = unescape(val[1]);
  }
  return hash;
}
