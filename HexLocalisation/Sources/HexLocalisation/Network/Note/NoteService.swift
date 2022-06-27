//
//  NoteService.swift
//  
//
//  Created by Packiaseelan S on 22/06/22.
//

import Foundation
import GRPC
import NIOPosix
import Combine

class NoteService {
    
    static let shared = NoteService()
    
    @Published var notes: [NoteModel] = []
    @Published var note: NoteModel?
    @Published private var grpcNotes: [Note] = []
    @Published private var grpcNote: Note?
    
    private var client: NoteServiceAsyncClient?
    private var cancellables = Set<AnyCancellable>()
    
    private init () {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let connection = ConnectionTarget.host(
            Network.note.host, port: Network.note.port
        )
        
        do {
            let channel = try GRPCChannelPool.with(
                target: connection,
                transportSecurity: .plaintext,
                eventLoopGroup: group
            )
            client = NoteServiceAsyncClient(channel: channel)
            //
            addSubscribers()
        } catch let error {
            print("Error init service client: \(error)")
        }
    }
    
    func getNotes() async {
        if let client = client {
            do {
                let response: NoteList = try await client.list(Empty())
                grpcNotes = response.notes
            } catch let error {
                print("Error getting notes. \(error)")
            }
        }
    }
    
    func getNote(id: String) async {
        let request = NoteRequestId(id: id)
        if let client = client {
            do {
                grpcNote = try await client.get(request)
            } catch let error {
                print("Error getting note for \(id)... \(error)")
            }
        }
    }
    
    private func addSubscribers() {
        $grpcNotes
            .map { (gNotes) -> [NoteModel] in
                var notes: [NoteModel] = []
                for gNote in gNotes {
                    notes.append(self.mapGrpcModel(gNote: gNote))
                }
                return notes
            }
            .sink { [weak self] notes in
                self?.notes = notes
            }
            .store(in: &cancellables)
    }
    
    private func mapGrpcModel(gNote: Note) -> NoteModel {
        return NoteModel(id: gNote.id, title: gNote.title, content: gNote.content)
    }
}

struct NoteModel: Identifiable {
    let id: String
    let title: String
    let content: String
}

extension NoteRequestId {
    init(id: String) {
        self.id = id
    }
}
                                    
extension Note {
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
