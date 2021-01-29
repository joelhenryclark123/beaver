// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class BeaverQueryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query BeaverQuery {
      allCourses {
        __typename
        id
        name
        term {
          __typename
          endAt
          startAt
        }
        assignmentsConnection {
          __typename
          nodes {
            __typename
            id
            name
            dueAt
          }
        }
      }
    }
    """

  public let operationName: String = "BeaverQuery"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("allCourses", type: .list(.nonNull(.object(AllCourse.selections)))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allCourses: [AllCourse]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "allCourses": allCourses.flatMap { (value: [AllCourse]) -> [ResultMap] in value.map { (value: AllCourse) -> ResultMap in value.resultMap } }])
    }

    /// All courses viewable by the current user
    public var allCourses: [AllCourse]? {
      get {
        return (resultMap["allCourses"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [AllCourse] in value.map { (value: ResultMap) -> AllCourse in AllCourse(unsafeResultMap: value) } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [AllCourse]) -> [ResultMap] in value.map { (value: AllCourse) -> ResultMap in value.resultMap } }, forKey: "allCourses")
      }
    }

    public struct AllCourse: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Course"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("term", type: .object(Term.selections)),
          GraphQLField("assignmentsConnection", type: .object(AssignmentsConnection.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, term: Term? = nil, assignmentsConnection: AssignmentsConnection? = nil) {
        self.init(unsafeResultMap: ["__typename": "Course", "id": id, "name": name, "term": term.flatMap { (value: Term) -> ResultMap in value.resultMap }, "assignmentsConnection": assignmentsConnection.flatMap { (value: AssignmentsConnection) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var term: Term? {
        get {
          return (resultMap["term"] as? ResultMap).flatMap { Term(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "term")
        }
      }

      /// returns a list of assignments.
      /// 
      /// **NOTE**: for courses with grading periods, this will only return grading
      /// periods in the current course; see `AssignmentFilter` for more info.
      /// In courses with grading periods that don't have students, it is necessary
      /// to *not* filter by grading period to list assignments.
      public var assignmentsConnection: AssignmentsConnection? {
        get {
          return (resultMap["assignmentsConnection"] as? ResultMap).flatMap { AssignmentsConnection(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "assignmentsConnection")
        }
      }

      public struct Term: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Term"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("endAt", type: .scalar(String.self)),
            GraphQLField("startAt", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(endAt: String? = nil, startAt: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Term", "endAt": endAt, "startAt": startAt])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var endAt: String? {
          get {
            return resultMap["endAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "endAt")
          }
        }

        public var startAt: String? {
          get {
            return resultMap["startAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "startAt")
          }
        }
      }

      public struct AssignmentsConnection: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["AssignmentConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "AssignmentConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A list of nodes.
        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Assignment"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("dueAt", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, name: String? = nil, dueAt: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Assignment", "id": id, "name": name, "dueAt": dueAt])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// when this assignment is due
          public var dueAt: String? {
            get {
              return resultMap["dueAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "dueAt")
            }
          }
        }
      }
    }
  }
}
