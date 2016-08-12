//
//  Edge.swift
//  Cartography
//
//  Created by Robert Böhnke on 17/06/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

public enum Edge : Property {
    case Top(View)
    case Right(View)
    case Bottom(View)
    case Left(View)

    case Leading(View)
    case Trailing(View)

    case CenterX(View)
    case CenterY(View)

    case Baseline(View)

    var view: View {
        switch (self) {
            case let .Top(view): return view
            case let .Right(view): return view
            case let .Bottom(view): return view
            case let .Left(view): return view

            case let .Leading(view): return view
            case let .Trailing(view): return view

            case let .CenterX(view): return view
            case let .CenterY(view): return view

            case let .Baseline(view): return view
        }
    }

    var attribute: NSLayoutAttribute {
        switch (self) {
            case .Top(_): return NSLayoutAttribute.Top
            case .Right(_): return NSLayoutAttribute.Right
            case .Bottom(_): return NSLayoutAttribute.Bottom
            case .Left(_): return NSLayoutAttribute.Left

            case .Leading(_): return NSLayoutAttribute.Leading
            case .Trailing(_): return NSLayoutAttribute.Trailing

            case .CenterX(_): return NSLayoutAttribute.CenterX
            case .CenterY(_): return NSLayoutAttribute.CenterY

            case .Baseline(_): return NSLayoutAttribute.LastBaseline
        }
    }
}

// Equality

public func ==(lhs: Edge, rhs: Expression<Edge>) -> NSLayoutConstraint {
    return apply(lhs, coefficients: rhs.coefficients[0], to: rhs.value)
}

public func ==(lhs: Expression<Edge>, rhs: Edge) -> NSLayoutConstraint {
    return rhs == lhs
}

public func ==(lhs: Edge, rhs: Edge) -> NSLayoutConstraint {
    return apply(lhs, to: rhs)
}

// Inequality

public func <=(lhs: Edge, rhs: Edge) -> NSLayoutConstraint {
    return apply(lhs, to: rhs, relation: NSLayoutRelation.LessThanOrEqual)
}

public func >=(lhs: Edge, rhs: Edge) -> NSLayoutConstraint {
    return apply(lhs, to: rhs, relation: NSLayoutRelation.GreaterThanOrEqual)
}

public func <=(lhs: Edge, rhs: Expression<Edge>) -> NSLayoutConstraint {
    return apply(lhs, coefficients: rhs.coefficients[0], to: rhs.value, relation: NSLayoutRelation.LessThanOrEqual)
}

public func <=(lhs: Expression<Edge>, rhs: Edge) -> NSLayoutConstraint {
    return rhs >= lhs
}

public func >=(lhs: Edge, rhs: Expression<Edge>) -> NSLayoutConstraint {
    return apply(lhs, coefficients: rhs.coefficients[0], to: rhs.value, relation: NSLayoutRelation.GreaterThanOrEqual)
}

public func >=(lhs: Expression<Edge>, rhs: Edge) -> NSLayoutConstraint {
    return rhs <= lhs
}

// Addition

public func +(c: Float, rhs: Edge) -> Expression<Edge> {
    return Expression(rhs, [ Coefficients(1, c) ])
}

public func +(lhs: Edge, rhs: Float) -> Expression<Edge> {
    return rhs + lhs
}

public func +(c: Float, rhs: Expression<Edge>) -> Expression<Edge> {
    return Expression(rhs.value, rhs.coefficients.map { $0 + c })
}

public func +(lhs: Expression<Edge>, rhs: Float) -> Expression<Edge> {
    return rhs + lhs
}

// Subtraction

public func -(c: Float, rhs: Edge) -> Expression<Edge> {
    return Expression(rhs, [ Coefficients(1, -c) ])
}

public func -(lhs: Edge, rhs: Float) -> Expression<Edge> {
    return rhs - lhs
}

public func -(c: Float, rhs: Expression<Edge>) -> Expression<Edge> {
    return Expression(rhs.value, rhs.coefficients.map { $0 - c})
}

public func -(lhs: Expression<Edge>, rhs: Float) -> Expression<Edge> {
    return rhs - lhs
}

// Multiplication

public func *(m: Float, rhs: Expression<Edge>) -> Expression<Edge> {
    return Expression(rhs.value, rhs.coefficients.map { $0 * m })
}

public func *(lhs: Expression<Edge>, rhs: Float) -> Expression<Edge> {
    return rhs * lhs
}

public func *(m: Float, rhs: Edge) -> Expression<Edge> {
    return Expression(rhs, [ Coefficients(m, 0) ])
}

public func *(lhs: Edge, rhs: Float) -> Expression<Edge> {
    return rhs * lhs
}

// Division

public func /(m: Float, rhs: Expression<Edge>) -> Expression<Edge> {
    return Expression(rhs.value, rhs.coefficients.map { $0 / m })
}

public func /(lhs: Expression<Edge>, rhs: Float) -> Expression<Edge> {
    return rhs / lhs
}

public func /(m: Float, rhs: Edge) -> Expression<Edge> {
    return Expression(rhs, [ Coefficients(1 / m, 0) ])
}

public func /(lhs: Edge, rhs: Float) -> Expression<Edge> {
    return rhs / lhs
}
