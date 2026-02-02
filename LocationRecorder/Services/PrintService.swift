//
//  PrintService.swift
//  LocationRecorder
//
//  Created by Scott Owen on 2/2/26.
//

import UIKit

final class PrintService {

    func printText(_ text: String) {
        let controller = UIPrintInteractionController.shared

        let formatter = UISimpleTextPrintFormatter(text: text)
        formatter.perPageContentInsets = UIEdgeInsets(top: 36, left: 36, bottom: 36, right: 36)

        let info = UIPrintInfo(dictionary: nil)
        info.outputType = .general
        info.jobName = "Location History"

        controller.printInfo = info
        controller.printFormatter = formatter

        controller.present(animated: true, completionHandler: nil)
    }
}
