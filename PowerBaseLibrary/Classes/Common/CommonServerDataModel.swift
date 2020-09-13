//
//  CommonServerDataModel.swift
//  PowerBaseLibrary
//
//  Created by 邹程 on 2019/9/6.
//

import HandyJSON

public class ServerDataModel: HandyJSON {
    public var apver: String?
    public var other: String?
    public var result: Any?

    public required init() {}
}

public class CommonServerDataModel: HandyJSON {
    public var code: String?
    public var data: ServerDataModel?
    public var msg: String?
    public var emptyData: Bool = false
    public var jsonString: String?

    public required init() {}
}
