# pneumo_core
A disordered collection of scripts to get some stats about core genes of S. pneumoniae

See http://www.johnlees.me/blog/2019/04/17/conservation-of-core-genes-in-s-pneumoniae/

## Details
A bit of a mess! Key scripts:

* `run_hyphy_SLAC.pl` - Runs IQTREE and SLAC (using HyPhy).
* `parse_SLAC_json.pl` – A terrible way to parse the output from the
  above and extract the global dN/dS.
* `calc_pi.py` - Calculates the pi values.
* `interactive_plot.R` - Creates the table and plot from the blog.

