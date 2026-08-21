/*-------------------------------------------------------------------------------------------------------------------------
     File: Compass.swift
   Author: Kevin Messina
  Created: 2/3/26
 Modified: 08/21/2026 05:45 PM EDT
  Version: 23
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.
 
©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

public struct CompassView: View {
    @Binding var currentPosition: Double
    var showReadout: Bool = false
    @State private var displayedAngle: Double = 0

    public init(currentPosition: Binding<Double>, showReadout: Bool = false) {
        _currentPosition = currentPosition
        self.showReadout = showReadout
    }

    private let borderColor: Color = .white.opacity(0.72)
    private let backgroundColor: Color = Color(red: 0.16, green: 0.16, blue: 0.17)
    private let tickColor: Color = Color.white.opacity(0.58)
    private let mediumTickColor: Color = Color.white.opacity(0.44)
    private let minorTickColor: Color = Color.white.opacity(0.34)
    private let currentTickColor: Color = Color(red: 1.0, green: 0.37, blue: 0.41)
    private let labelColor: Color = .white
    private let labelSize: CGFloat = 18.0
    private let faceSize: CGFloat = 300
    private let rimSize: CGFloat = 308
    private let labelContentSize: CGFloat = 244
    private let majorTickContentSize: CGFloat = 290
    private let minorTickContentSize: CGFloat = 290
    private let labelInset: CGFloat = 2
    private let pointerLength: CGFloat = 184
    private let pointerWidth: CGFloat = 26
    private let loupeSize: CGFloat = 52
    private let pointerYOffset: CGFloat = 106
    private let fiveDegreeTickDegrees = stride(from: 5.0, to: 360.0, by: 5.0).filter { Int($0).isMultiple(of: 45) == false }
    private let directions = [
        (abbrev: "N", name: "North", degree: 0.0),
        (abbrev: "NE", name: "Northeast", degree: 45.0),
        (abbrev: "E", name: "East", degree: 90.0),
        (abbrev: "SE", name: "Southeast", degree: 135.0),
        (abbrev: "S", name: "South", degree: 180.0),
        (abbrev: "SW", name: "Southwest", degree: 225.0),
        (abbrev: "W", name: "West", degree: 270.0),
        (abbrev: "NW", name: "Northwest", degree: 315.0)
    ]

    private struct VerticalNeedleHalf: Shape {
        var pointsUp: Bool

        func path(in rect: CGRect) -> Path {
            var path = Path()
            let midX = rect.midX
            let midY = rect.midY

            if pointsUp {
                path.move(to: CGPoint(x: midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: midY))
                path.addLine(to: CGPoint(x: rect.minX, y: midY))
            } else {
                path.move(to: CGPoint(x: midX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: midY))
                path.addLine(to: CGPoint(x: rect.minX, y: midY))
            }

            path.closeSubpath()
            return path
        }
    }

    private var normalizedPosition: Double {
        normalizedAngle(currentPosition)
    }

    private func currentDirection() -> (abbrev: String, name: String, degree: Double) {
        let wrappedAngle = normalizedPosition
        let wrappedSectorAngle = (wrappedAngle + 22.5).truncatingRemainder(dividingBy: 360)
        let sectorIndex = Int(wrappedSectorAngle / 45.0) % directions.count
        return directions[sectorIndex]
    }

    private func closestDisplayAngle(for target: Double, from reference: Double) -> Double {
        var delta = target - normalizedAngle(reference)

        if delta > 180 {
            delta -= 360
        } else if delta < -180 {
            delta += 360
        }

        return reference + delta
    }

    private func updateAngle(to location: CGPoint, center: CGPoint) {
        let radians = atan2(location.y - center.y, location.x - center.x)
        var newDegrees = (Double(radians) * 180 / .pi) + 90

        if newDegrees < 0 {
            newDegrees += 360
        }

        let normalizedDegrees = normalizedAngle(newDegrees.rounded())
        displayedAngle = closestDisplayAngle(for: normalizedDegrees, from: displayedAngle)
        currentPosition = normalizedDegrees
    }

    private func normalizedAngle(_ angle: Double) -> Double {
        let wrappedValue = angle.truncatingRemainder(dividingBy: 360)
        return wrappedValue < 0 ? wrappedValue + 360 : wrappedValue
    }

    public var body: some View {
        VStack(spacing: 28) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                backgroundColor.opacity(0.98),
                                backgroundColor,
                                Color.black.opacity(0.98)
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: faceSize * 0.62
                        )
                    )
                    .frame(width: faceSize, height: faceSize)
                    .shadow(color: .black.opacity(0.42), radius: 24, x: 0, y: 14)

                ForEach(directions, id: \.name) { direction in
                    VStack(spacing: 8) {
                        Text(direction.abbrev)
                            .foregroundColor(labelColor)
                            .font(.system(size: labelSize, weight: .bold, design: .rounded))
                            .rotationEffect(.degrees(-direction.degree))
                            .padding(.top, labelInset)
                            .shadow(color: .black.opacity(0.45), radius: 3, x: 0, y: 1)

                        Spacer()
                    }
                    .frame(width: labelContentSize, height: labelContentSize)
                    .rotationEffect(.degrees(direction.degree))
                }

                ForEach(directions, id: \.name) { direction in
                    VStack(spacing: 0) {
                        ZStack {
                            Capsule()
                                .fill(Color.black.opacity(0.55))
                                .frame(width: 5, height: 18)
                                .offset(x: 1.25, y: 1.5)
                                .blur(radius: 1)

                            Capsule()
                                .fill(tickColor)
                                .overlay(
                                    Capsule()
                                        .stroke(
                                            LinearGradient(
                                                colors: [.white.opacity(0.34), .clear],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .frame(width: 4, height: 16)
                        }

                        Spacer()
                    }
                    .frame(width: majorTickContentSize, height: majorTickContentSize)
                    .rotationEffect(.degrees(direction.degree))
                }

                ForEach(fiveDegreeTickDegrees, id: \.self) { degree in
                    VStack(spacing: 0) {
                        let isMediumTick = Int(degree).isMultiple(of: 15)
                        let shadowHeight: CGFloat = isMediumTick ? 18 : 15
                        let tickHeight: CGFloat = isMediumTick ? 16 : 13
                        let tickWidth: CGFloat = isMediumTick ? 3 : 2

                        ZStack {
                            Capsule()
                                .fill(Color.black.opacity(0.45))
                                .frame(width: tickWidth + 1, height: shadowHeight)
                                .offset(x: 1, y: 1)
                                .blur(radius: 0.8)

                            Capsule()
                                .fill(isMediumTick ? mediumTickColor : minorTickColor)
                                .frame(width: tickWidth, height: tickHeight)
                        }

                        Spacer()
                    }
                    .frame(width: minorTickContentSize, height: minorTickContentSize)
                    .rotationEffect(.degrees(degree))
                }

                ZStack {
                    ZStack {
                        VerticalNeedleHalf(pointsUp: true)
                            .fill(
                                LinearGradient(
                                    colors: [currentTickColor.opacity(0.92), Color.red.opacity(0.78)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                VerticalNeedleHalf(pointsUp: true)
                                    .stroke(Color.red.opacity(0.25), lineWidth: 1)
                            )

                        VerticalNeedleHalf(pointsUp: false)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.96), Color.white.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                VerticalNeedleHalf(pointsUp: false)
                                    .stroke(Color.black.opacity(0.16), lineWidth: 1)
                            )
                    }
                    .frame(width: pointerWidth, height: pointerLength)
                    .shadow(color: .black.opacity(0.28), radius: 4, x: 0, y: 2)

                    Circle()
                        .stroke(currentTickColor, lineWidth: 3)
                        .frame(width: loupeSize, height: loupeSize)
                        .background(Circle().fill(Color(red: 0.21, green: 0.33, blue: 0.39).opacity(0.95)))
                        .overlay(
                            Text(currentDirection().abbrev)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.88))
                        )
                        .offset(y: -pointerYOffset)
                        .highPriorityGesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .named("compass"))
                                .onChanged { value in
                                    updateAngle(
                                        to: value.location,
                                        center: CGPoint(x: faceSize / 2, y: faceSize / 2)
                                    )
                                }
                        )
                }
                .frame(width: labelContentSize, height: labelContentSize)
                .rotationEffect(.degrees(displayedAngle))
                .animation(.interactiveSpring(response: 0.16, dampingFraction: 0.9), value: displayedAngle)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(red: 0.28, green: 0.28, blue: 0.3), .black],
                            center: .topLeading,
                            startRadius: 1,
                            endRadius: 15
                        )
                    )
                    .frame(width: 18, height: 18)
                    .overlay(Circle().stroke(Color.white.opacity(0.55), lineWidth: 1))

                Circle()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .white.opacity(0.14), location: 0.0),
                                .init(color: .white.opacity(0.04), location: 0.28),
                                .init(color: .clear, location: 0.5),
                                .init(color: .black.opacity(0.12), location: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: faceSize, height: faceSize)
                    .allowsHitTesting(false)
            }
            .overlay(
                ZStack {
                    Circle()
                        .stroke(borderColor, lineWidth: 3)
                        .frame(width: rimSize, height: rimSize)
                        .shadow(color: .black.opacity(0.85), radius: 10, x: 0, y: 2)
                }
            )
            .contentShape(Circle())
            .coordinateSpace(name: "compass")
            .sensoryFeedback(.selection, trigger: Int(normalizedPosition))
            .onAppear {
                displayedAngle = normalizedPosition
            }
            .onChange(of: currentPosition) { _, newValue in
                let normalizedValue = normalizedAngle(newValue)
                displayedAngle = closestDisplayAngle(for: normalizedValue, from: displayedAngle)
            }

            if showReadout {
                HStack(spacing: 10) {
                    Text("\(Int(normalizedPosition))°")
                    Text("・")
                    Text(currentDirection().name)
                }
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.94))
                .transition(.opacity.combined(with: .scale))
                .padding(.top, -6)
            }
        }
    }
}

#Preview {
    @Previewable @State var currentPosition: Double = 271

    ZStack {
        Color.black
            .ignoresSafeArea()

        CompassView(currentPosition: $currentPosition, showReadout: true)
            .padding()
    }
}
