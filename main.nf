process create_grid {
  echo {params.verbose != null ? true : false}

  publishDir "${params.outdir}/", mode: 'copy', saveAs: { filename -> "${params.id}_$filename" }
  
  input:
    file "data.csv" from Channel.fromPath("$params.input")
  
  output:
    file "grid.txt" into grid
  
  script:
    template 'create_grid.R'
  
}

process create_histograms {
  echo {params.verbose != null ? true : false}

  publishDir "${params.outdir}/", mode: 'copy', saveAs: { filename -> "${params.id}_$filename" }
  
  input:
    file "grid.txt" from grid
  
  output:
    file "x_histogram.txt"
    file "y_histogram.txt"

  when:
    params.histogram != 'NOT PROVIDED'
  
  script:
    template 'create_histograms.R'
  
}
