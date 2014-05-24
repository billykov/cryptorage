jQuery(document).ready(function(){

    jQuery('.table tbody tr').each(function (){
        findRowMaxMin(jQuery(this));
    })
});

function findRowMaxMin(row, maxClass, minClass){
    maxClass = maxClass || 'row-max';
    minClass = minClass || 'row-min';
    var cellWithMax;
    var cellWithMin;
    var maxValue;
    var minValue;
    row.find('td.getMax').each(function(){
        var cellVal = Number(jQuery(this).text());
        if (isNaN(maxValue) || cellVal > maxValue) {
            cellWithMax = jQuery(this);
            maxValue = cellVal;
        }
        if (isNaN(minValue) || cellVal < minValue) {
            cellWithMin = jQuery(this);
            minValue = cellVal;
        }
    });
    if (cellWithMax) {
        cellWithMax.addClass(maxClass).attr('title',(maxValue-minValue));
        cellWithMin.addClass(minClass);
    }

}

