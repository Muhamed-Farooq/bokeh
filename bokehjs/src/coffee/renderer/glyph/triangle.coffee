
define [
  "underscore",
  "renderer/properties",
  "./marker",
], (_, Properties, Marker) ->

  class TriangleView extends Marker.View

    _properties: ['line', 'fill']

    _render: (ctx, glyph_props, use_selection) ->
      for i in @mask

        if isNaN(@sx[i] + @sy[i] + @size[i])
          continue
        if use_selection and not @selected_mask[i]
          continue
        if use_selection == false and @selected_mask[i]
          continue

        a = @size[i] * Math.sqrt(3)/6
        r = @size[i]/2
        h = @size[i] * Math.sqrt(3)/2
        ctx.beginPath()
        # TODO (bev) use viewstate to take y-axis inversion into account
        ctx.moveTo(@sx[i]-r, @sy[i]+a)
        ctx.lineTo(@sx[i]+r, @sy[i]+a)
        ctx.lineTo(@sx[i],   @sy[i]+a-h)
        ctx.closePath()

        if glyph_props.fill_properties.do_fill
          glyph_props.fill_properties.set_vectorize(ctx, i)
          ctx.fill()

        if glyph_props.line_properties.do_stroke
          glyph_props.line_properties.set_vectorize(ctx, i)
          ctx.stroke()

    draw_legend: (ctx, x1, x2, y1, y2) ->
      glyph_props = @glyph_props
      line_props = glyph_props.line_properties
      fill_props = glyph_props.fill_properties
      ctx.save()
      reference_point = @get_reference_point()
      if reference_point?
        glyph_settings = reference_point
        data_r = @distance([reference_point], 'x', 'size', 'edge')[0]
      else
        glyph_settings = glyph_props
        data_r = glyph_props.select('size', glyph_props).default
      border = line_props.select(line_props.line_width_name, glyph_settings)
      d = _.min([Math.abs(x2-x1), Math.abs(y2-y1)])
      d = d - 2 * border
      r = d / 2
      if data_r?
        r = if data_r > r then r else data_r
      x = (x1 + x2) / 2.0
      y = (y1 + y2) / 2.0
      a = @size[i] * Math.sqrt(3)/6
      r = @size[i]/2
      h = @size[i] * Math.sqrt(3)/2
      ctx.beginPath()
      # TODO use viewstate to take y-axis inversion into account
      ctx.moveTo(@sx[i]-r, @sy[i]+a)
      ctx.lineTo(@sx[i]+r, @sy[i]+a)
      ctx.lineTo(@sx[i],   @sy[i]+a-h)
      ctx.closePath()
      if fill_props.do_fill
        fill_props.set(ctx, glyph_settings)
        ctx.fill()
      if line_props.do_stroke
        line_props.set(ctx, glyph_settings)
        ctx.stroke()

      ctx.restore()

  class Triangle extends Marker.Model
    default_view: TriangleView
    type: 'Glyph'

    display_defaults: () ->
      return _.extend(super(), {
        fill_color: 'gray'
        fill_alpha: 1.0
        line_color: 'red'
        line_width: 1
        line_alpha: 1.0
        line_join: 'miter'
        line_cap: 'butt'
        line_dash: []
        line_dash_offset: 0
      })

  return {
    "Model": Triangle,
    "View": TriangleView,
  }
