//
//  MainMenuView.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                DottedBackground()
                    .ignoresSafeArea()

                RoundedRectangle(cornerRadius: 46)
                    .fill(Color.mint.opacity(0.22))
                    .frame(width: 340, height: 640)

                VStack(spacing: 18) {
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color.white.opacity(0.60))
                        .frame(width: 280, height: 200)
                        .overlay(
                            Text("Processing,\nOutput Screen,\nOther Menu\nPossibilities")
                                .font(.system(size: 28, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                                .padding()
                        )
                        .padding(.top, 20)

                    Spacer()

                    VStack(spacing: 16) {
                        NavigationLink {
                            RecordLocationView()
                        } label: {
                            MenuButtonLabel(title: "Record Location")
                        }

                        NavigationLink {
                            HistoryListView()
                        } label: {
                            MenuButtonLabel(title: "View Location History")
                        }

                        NavigationLink {
                            PrintHistoryView()
                        } label: {
                            MenuButtonLabel(title: "Print Location History")
                        }
                    }
                    .padding(.horizontal, 30)

                    Spacer()
                    Spacer()
                }
                .frame(width: 340, height: 640)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MenuButtonLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.cyan.opacity(0.95))
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

struct DottedBackground: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 26
            let dotRadius: CGFloat = 1.6

            for y in stride(from: 12 as CGFloat, through: size.height, by: spacing) {
                for x in stride(from: 12 as CGFloat, through: size.width, by: spacing) {
                    let rect = CGRect(x: x, y: y, width: dotRadius * 2, height: dotRadius * 2)
                    context.fill(Path(ellipseIn: rect), with: .color(.gray.opacity(0.30)))
                }
            }
        }
        .background(Color.white)
    }
}
