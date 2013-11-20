class GraphsController < ApplicationController
  def index
    data_array_1 = [1, 4, 3, 5, 9]
    data_array_2 = [4, 2, 10, 4, 7]

    @bar_chart = Gchart.bar(
                :size => '600x400',
                :bar_colors => ['000000', '0088FF'],
                :title => "Bar graph",
                :bg => 'EFEFEF',
                :legend => ['first data set label', 'second data set label'],
                :data => [data_array_1, data_array_2],
                :filename => 'images/bar_chart.png',
                :stacked => false,
                :legend_position => 'bottom',
                :axis_with_labels => [['x'], ['y']],
                :max_value => 15,
                :min_value => 0,
                :axis_labels => [["A|B|C|D|E"]],
                )

    @line_chart = Gchart.line(
                :size => '600x400',
                :bar_colors => ['000000', '0088FF'],
                :title => "Line graph",
                :bg => 'EFEFEF',
                :legend => ['home_1', 'home_2'],
                :data => [data_array_1, data_array_2],
                :filename => 'images/bar_chart.png',
                :stacked => false,
                :legend_position => 'bottom',
                :axis_with_labels => [['x'], ['y']],
                :max_value => 15,
                :min_value => 0,
                :axis_labels => [["Jan|Feb|Mar|Apr|May|June|July|Aug|Sept|Oct|Nov|Dec"]],
                )  
    end
end
