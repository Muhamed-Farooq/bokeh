import {Scale} from "./scale"
import {Arrayable} from "core/types"
import {linspace} from "core/util/array"
import {map, interpolate, norm} from "core/util/arrayable"
import * as p from "core/properties"

export namespace LerpScale {
  export type Attrs = p.AttrsOf<Props>

  export type Props = Scale.Props
}

export interface LerpScale extends LerpScale.Attrs {
  scan_result: number[]
}

export class LerpScale extends Scale {
  properties: LerpScale.Props

  constructor(attrs?: Partial<LerpScale.Attrs>) {
    super(attrs)
  }

  static initClass(): void {
    this.prototype.type = "LerpScale"
    this.internal({scan_result: [ p.Any ]})
  }

  compute(x: number): number {
    return x
  }

  v_compute(xs: Arrayable<number>): Arrayable<number> {
    const norm_xs = norm(xs, this.source_range.start, this.source_range.end)
    const edges_norm = linspace(0, 1, this.scan_result.length)
    const interpolated = interpolate(norm_xs, edges_norm, this.scan_result)
    const norm_interp = norm(interpolated, this.source_range.start, this.source_range.end)

    const {start, end} = this.target_range
    return map(norm_interp, x => start + x*(end - start))
  }

  invert(xprime: number): number {
    return xprime
  }

  v_invert(xprimes: Arrayable<number>): Arrayable<number> {
    return xprimes
  }

  _compute_state(): [number, number] {
    return [0, 0]
  }
}
LerpScale.initClass()
